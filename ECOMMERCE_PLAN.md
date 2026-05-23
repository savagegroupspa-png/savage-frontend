# PLAN E-COMMERCE — SAVAGE GROUP SpA
**Fecha:** 2026-05-23  
**Stack actual:** Astro v6 · Express.js · MongoDB · Railway (backend) · Netlify (frontend)  
**Dominio:** drinkssavage.com  

---

## 1. OPCIONES DE PASARELA EVALUADAS

| Opción | Popularidad Chile | Dificultad integración | Comisión aprox. | Recomendación |
|---|---|---|---|---|
| MercadoPago | Alta | Baja | ~3.49% | Buena si se expande a Latam |
| Flow.cl | Alta | Baja | ~2.95% | Buena alternativa local |
| **Transbank Webpay Plus** | **Muy alta** | **Media** | **~2.35%** | ✅ **Recomendada** |
| Stripe | Media | Baja | ~2.9% + $0.30 USD | Solo si target es internacional |
| Khipu | Media | Baja | ~1.5% | Solo transferencias bancarias |

### ¿Por qué Transbank Webpay Plus?
- Es el estándar de pago en Chile (Falabella, Paris, Ripley lo usan)
- Mayor tasa de conversión por confianza del usuario
- Acepta débito, crédito y prepago en un solo checkout
- Menor comisión entre las opciones evaluadas
- SDK oficial en Node.js disponible

---

## 2. ARQUITECTURA DEL SISTEMA

```
[drinkssavage.com]                    [Railway Backend]
SeccionTienda.astro                   Express.js API
  └── Seleccionar producto            /api/pagos/iniciar
  └── Elegir cantidad          ──────►    └── Crea transacción en Transbank
  └── Click "Pagar con Webpay"             └── Devuelve URL + token
        │                             /api/pagos/confirmar
        │ redirect                        └── Confirma pago con Transbank
        ▼                                 └── Guarda orden en MongoDB
[Checkout Transbank]                       └── Envía email confirmación
        │
        │ redirect (éxito/fallo)
        ▼
pago-exitoso.astro / pago-fallido.astro
```

---

## 3. LO QUE SE DEBE DEFINIR ANTES DE IMPLEMENTAR

### 3.1 Datos del producto
- [ ] **Precio por lata** (en CLP)
- [ ] **Modalidades de venta**: ¿unidad, pack x6, pack x12?
- [ ] **Precio por pack** (si aplica)
- [ ] **¿Hay stock limitado?** → si sí, necesita campo en MongoDB
- [ ] **¿Se hace despacho a domicilio?** → si sí, ¿costo de envío fijo o por zona?

### 3.2 Credenciales Transbank (modo prueba — gratuitas)
Las credenciales de sandbox son públicas y las provee Transbank directamente:
- `commerce_code`: `597055555532` (prueba Webpay Plus)
- `api_key`: `579B532A7440BB0C9079DED94D31EA1615BACEB56610332264630D42D0A36B1C`
- Estas son fijas para desarrollo, no hay que solicitarlas

### 3.3 Credenciales producción (requiere trámite con Transbank)
- [ ] Crear cuenta en transbank.cl/soluciones-para-tu-negocio
- [ ] Documentos requeridos:
  - RUT de la empresa (Savage Group SpA)
  - Escritura de constitución
  - Cuenta bancaria a nombre de la empresa
  - Formulario de afiliación Transbank
- [ ] Plazo estimado: 5–10 días hábiles
- [ ] Transbank entrega: `commerce_code` y `api_key` de producción
- [ ] Reemplazar en `.env` del backend en Railway

---

## 4. TRABAJO BACKEND — Express.js en Railway

### 4.1 Instalación
```bash
npm install transbank-sdk
```

### 4.2 Variables de entorno a agregar en Railway
```env
# MODO PRUEBA (usar estas hasta tener credenciales reales)
TB_COMMERCE_CODE=597055555532
TB_API_KEY=579B532A7440BB0C9079DED94D31EA1615BACEB56610332264630D42D0A36B1C
TB_ENVIRONMENT=integration   # cambiar a "production" cuando esté listo

# URLS DE RETORNO
TB_RETURN_URL=https://drinkssavage.com/pago-confirmar
TB_FINAL_URL_SUCCESS=https://drinkssavage.com/pago-exitoso
TB_FINAL_URL_FAILURE=https://drinkssavage.com/pago-fallido
```

### 4.3 Archivos a crear en el backend

```
savage_backend/src/
├── models/
│   └── Orden.js              ← modelo MongoDB para órdenes
├── controllers/
│   └── pagoController.js     ← lógica Transbank
└── routes/
    └── pagoRoutes.js         ← endpoints /api/pagos/*
```

### 4.4 Modelo Orden (MongoDB)

```js
// src/models/Orden.js
{
  token: String,              // token de Transbank
  estado: String,             // 'pendiente' | 'aprobado' | 'rechazado'
  items: [{
    sabor: String,            // 'passion_fruit' | 'pineapple' | 'mango' | 'exotic'
    cantidad: Number,
    precio_unitario: Number,
  }],
  total: Number,              // en CLP
  nombre_cliente: String,
  email_cliente: String,
  telefono_cliente: String,
  direccion_envio: String,    // si se implementa despacho
  fecha: Date,
  transbank_response: Object  // respuesta completa de Transbank
}
```

### 4.5 Endpoints a crear

#### POST `/api/pagos/iniciar`
- Recibe: `{ items, cliente: { nombre, email, telefono } }`
- Calcula el total
- Crea transacción en Transbank con `WebpayPlus.Transaction.create()`
- Guarda orden en MongoDB con estado `pendiente`
- Devuelve: `{ url, token }` → el frontend redirige al usuario

#### POST `/api/pagos/confirmar`
- Recibe: `{ token_ws }` (Transbank lo envía al return_url)
- Confirma la transacción con `WebpayPlus.Transaction.commit()`
- Actualiza orden en MongoDB: estado `aprobado` o `rechazado`
- Si aprobado: envía email de confirmación via Nodemailer (ya instalado)
- Redirige a `/pago-exitoso` o `/pago-fallido`

---

## 5. TRABAJO FRONTEND — Astro

### 5.1 Archivos a crear

```
savage_frontend/src/
├── components/
│   └── SeccionTienda.astro   ← sección de compra en la página principal
├── pages/
│   ├── pago-exitoso.astro    ← pantalla de confirmación
│   └── pago-fallido.astro    ← pantalla de error/reintento
```

### 5.2 SeccionTienda.astro — diseño
- Grid de los 4 sabores (imágenes Cloudinary ya disponibles)
- Selector de cantidad por sabor
- Resumen del pedido con total en CLP
- Formulario: nombre, email, teléfono, dirección (si hay despacho)
- Botón "PAGAR CON WEBPAY" → llama a `/api/pagos/iniciar` → redirige

### 5.3 Imágenes Cloudinary disponibles (ya en producción)
| Sabor | URL Cloudinary |
|---|---|
| Passion Fruit (Maracuyá) | `v1778291084/maracuya_1_SF_ctm8kv.png` |
| Pineapple (Piña) | `v1778291084/piña_3_SF_u1oelo.png` |
| Creamy Mango | `v1778291084/mango_2_SF_p5dzce.png` |
| Exotic Soursop (Durazno) | `v1778291084/durazno_4_SF_kqavow.png` |
| Base URL | `https://res.cloudinary.com/dauuk5yar/image/upload/` |

### 5.4 Página pago-exitoso.astro
- Muestra: número de orden, sabores comprados, total
- CTA: "SEGUIR EN INSTAGRAM" + "VER MÁS PRODUCTOS"
- Lee los parámetros que Transbank devuelve por URL

### 5.5 Página pago-fallido.astro
- Mensaje de error claro y sin tecnicismos
- CTA: "INTENTAR NUEVAMENTE" → vuelve a la tienda
- Log del error para debugging

---

## 6. AGREGAR AL NAVBAR

Añadir link `TIENDA` al menú de `BarraNavegacion.astro`:
```html
<a href="#tienda">TIENDA</a>
```

---

## 7. ORDEN DE IMPLEMENTACIÓN SUGERIDO

```
Semana 1 — Backend + pruebas
  [1] npm install transbank-sdk en savage_backend
  [2] Crear modelo Orden.js
  [3] Crear pagoController.js (iniciar + confirmar)
  [4] Crear pagoRoutes.js y registrar en index.js
  [5] Agregar variables de entorno en Railway (modo integration)
  [6] Probar flujo completo con tarjeta de prueba de Transbank

Semana 2 — Frontend
  [7] Crear SeccionTienda.astro
  [8] Crear pago-exitoso.astro y pago-fallido.astro
  [9] Agregar "TIENDA" al navbar
  [10] Probar flujo end-to-end en localhost + tunnel cloudflared

Semana 3 — Producción
  [11] Tramitar credenciales reales con Transbank
  [12] Cambiar TB_ENVIRONMENT=production en Railway
  [13] Deploy frontend en Netlify
  [14] Prueba de compra real con monto mínimo
```

---

## 8. TARJETAS DE PRUEBA TRANSBANK (modo integration)

| Tipo | Número | CVV | Expiración | Resultado |
|---|---|---|---|---|
| Visa (aprobada) | 4051 8856 0044 6623 | 123 | Cualquiera | ✅ Aprobado |
| Mastercard (aprobada) | 5186 0595 5959 0568 | 123 | Cualquiera | ✅ Aprobado |
| Visa (rechazada) | 4051 8842 3993 7763 | 123 | Cualquiera | ❌ Rechazado |
| RUT para autenticación | 11.111.111-1 | — | — | — |
| Clave para autenticación | 123 | — | — | — |

---

## 9. ESTIMACIÓN DE TRABAJO TÉCNICO

| Tarea | Tiempo estimado |
|---|---|
| Backend completo (modelo + endpoints) | 3–4 horas |
| Frontend SeccionTienda.astro | 2–3 horas |
| Páginas éxito/fallo | 1 hora |
| Pruebas end-to-end | 1–2 horas |
| **Total implementación** | **~8–10 horas** |

---

## 10. PENDIENTES PARA ACTIVAR

- [ ] Definir precio por lata (CLP)
- [ ] Definir modalidades de venta (unidad / pack)
- [ ] Decidir si hay despacho a domicilio y costo
- [ ] Tramitar credenciales Transbank producción
- [ ] Confirmar dominio definitivo (`drinkssavage.com`)
