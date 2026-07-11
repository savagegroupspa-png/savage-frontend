-- ═══════════════════════════════════════════════════════════════
-- DATOS DE SIMULACIÓN REALISTA — SAVAGE GROUP SpA
-- Ejecutar en Supabase SQL Editor DESPUÉS de crear las tablas
-- ═══════════════════════════════════════════════════════════════

-- ─── PASO 1: INSERTAR CLIENTES ───

INSERT INTO clientes (id, nombre, rut, tipo, telefono, email, direccion, ciudad, notas) VALUES
('a1000001-0000-0000-0000-000000000001', 'Botillería La Esquina', '76.543.210-1', 'local', '+56 9 8765 4321', 'laesquina@gmail.com', 'Av. Libertad 1520', 'Viña del Mar', 'Cliente desde enero 2026. Buen volumen de recompra mensual.'),
('a1000001-0000-0000-0000-000000000002', 'Minimarket Don Pancho', '77.654.321-2', 'local', '+56 9 7654 3210', 'donpancho.vlpo@gmail.com', 'Calle Condell 890', 'Valparaíso', 'Ubicación céntrica. Buena rotación de Passion Fruit y Exotic.'),
('a1000001-0000-0000-0000-000000000003', 'Distribuidora Reñaca SpA', '76.890.123-K', 'distribuidor', '+56 9 6543 2109', 'ventas@distribuidorarenaca.cl', 'Av. Borgoño 14500', 'Viña del Mar', 'Distribuidor principal V Región. Pedidos grandes mensuales.'),
('a1000001-0000-0000-0000-000000000004', 'Licorería Central', '78.123.456-3', 'local', '+56 9 5432 1098', 'licoreria.central@gmail.com', 'Av. Bernardo O''Higgins 1245', 'Santiago Centro', 'Punto de venta clave en el centro de Santiago.'),
('a1000001-0000-0000-0000-000000000005', 'Bar Rooftop Bellavista', '79.234.567-4', 'restaurant', '+56 9 4321 0987', 'contacto@rooftopbellavista.cl', 'Pío Nono 380, piso 8', 'Santiago', 'Bar premium. Compra para eventos y carta de tragos.'),
('a1000001-0000-0000-0000-000000000006', 'Supermercado Fresh Market', '80.345.678-5', 'cadena', '+56 9 3210 9876', 'compras@freshmarket.cl', 'Av. Providencia 2315', 'Providencia', 'Cadena retail. Pedidos grandes. Requiere material POP.'),
('a1000001-0000-0000-0000-000000000007', 'Almacén El Rincón', '81.456.789-6', 'local', '+56 9 2109 8765', 'elrincon.quilpue@gmail.com', 'Calle Freire 456', 'Quilpué', 'Almacén de barrio. Volumen menor pero constante.'),
('a1000001-0000-0000-0000-000000000008', 'Restaurant Ola Marina', '82.567.890-7', 'restaurant', '+56 9 1098 7654', 'reservas@olamarina.cl', 'Av. Borgoño 21500', 'Con Con', 'Restaurant costero. Compra Creamy Mango para cocteles.'),
('a1000001-0000-0000-0000-000000000009', 'Cadena Li-Cor Express', '83.678.901-8', 'cadena', '+56 9 9876 5432', 'gerencia@licorexpress.cl', 'Av. Apoquindo 4500', 'Las Condes', '3 sucursales en RM. Cliente de mayor volumen.'),
('a1000001-0000-0000-0000-000000000010', 'Tienda Gourmet Vitacura', '84.789.012-9', 'local', '+56 9 8765 1234', 'hola@gourmetvitacura.cl', 'Av. Vitacura 6800', 'Vitacura', 'Tienda premium. Nuevo cliente desde junio 2026.'),
('a1000001-0000-0000-0000-000000000011', 'Botillería Los Hermanos', '85.890.123-0', 'local', '+56 9 7654 0123', 'loshermanos.va@gmail.com', 'Av. Valparaíso 320', 'Villa Alemana', 'Buena ubicación. Interesados en Exotic Soursop.');


-- ─── PASO 2: INSERTAR TRANSACCIONES VINCULADAS ───

INSERT INTO transacciones (folio, tipo, cliente_proveedor, cliente_id, monto, fecha, descripcion) VALUES

-- ENERO 2026
('V-1001', 'venta', 'Botillería La Esquina — Viña del Mar', 'a1000001-0000-0000-0000-000000000001', 480000, '2026-01-08', '20 cajas Savage Passion Fruit x24 ($24.000 c/u)'),
('V-1002', 'venta', 'Minimarket Don Pancho — Valparaíso', 'a1000001-0000-0000-0000-000000000002', 312000, '2026-01-12', '13 cajas Savage Pineapple x24 ($24.000 c/u)'),
('V-1003', 'venta', 'Distribuidora Reñaca SpA', 'a1000001-0000-0000-0000-000000000003', 840000, '2026-01-18', '35 cajas mixtas Savage x24 ($24.000 c/u) — Pedido inaugural'),
('G-1001', 'gasto', 'Envases Plásticos del Pacífico Ltda.', NULL, 520000, '2026-01-10', 'Compra latas aluminio impresas — lote enero (2.000 unidades)'),
('G-1002', 'gasto', 'Transportes Rápidos Santiago S.A.', NULL, 145000, '2026-01-22', 'Flete Santiago → Valparaíso — 68 cajas'),

-- FEBRERO 2026
('V-1004', 'venta', 'Licorería Central — Santiago Centro', 'a1000001-0000-0000-0000-000000000004', 576000, '2026-02-03', '24 cajas Savage Creamy Mango x24 ($24.000 c/u)'),
('V-1005', 'venta', 'Bar Rooftop Bellavista', 'a1000001-0000-0000-0000-000000000005', 360000, '2026-02-10', '15 cajas Savage Exotic Soursop x24 ($24.000 c/u)'),
('V-1006', 'venta', 'Supermercado Fresh Market — Providencia', 'a1000001-0000-0000-0000-000000000006', 1200000, '2026-02-15', '50 cajas mixtas Savage x24 ($24.000 c/u) — Primer pedido cadena retail'),
('G-1003', 'gasto', 'Frutícola del Maule S.A.', NULL, 380000, '2026-02-08', 'Pulpa de maracuyá y piña congelada — 500 kg'),
('G-1004', 'gasto', 'Imprenta Digital Sur Ltda.', NULL, 95000, '2026-02-14', 'Stickers y material POP para góndola (500 unidades)'),
('P-1001', 'perdida', 'Merma interna — Bodega Viña', NULL, 72000, '2026-02-20', '3 cajas Passion Fruit dañadas en transporte (72 latas)'),

-- MARZO 2026
('V-1007', 'venta', 'Almacén El Rincón — Quilpué', 'a1000001-0000-0000-0000-000000000007', 216000, '2026-03-02', '9 cajas Savage Pineapple x24 ($24.000 c/u)'),
('V-1008', 'venta', 'Distribuidora Reñaca SpA', 'a1000001-0000-0000-0000-000000000003', 960000, '2026-03-08', '40 cajas mixtas Savage x24 ($24.000 c/u) — Reposición mensual'),
('V-1009', 'venta', 'Restaurant Ola Marina — Con Con', 'a1000001-0000-0000-0000-000000000008', 168000, '2026-03-12', '7 cajas Savage Creamy Mango x24 ($24.000 c/u)'),
('V-1010', 'venta', 'Botillería La Esquina — Viña del Mar', 'a1000001-0000-0000-0000-000000000001', 528000, '2026-03-18', '22 cajas mixtas Savage x24 ($24.000 c/u) — Recompra'),
('G-1005', 'gasto', 'Envases Plásticos del Pacífico Ltda.', NULL, 780000, '2026-03-05', 'Compra latas aluminio impresas — lote marzo (3.000 unidades)'),
('G-1006', 'gasto', 'Cloudinary Pro Plan', NULL, 29000, '2026-03-01', 'Hosting CDN de imágenes y video del sitio web — marzo'),
('G-1007', 'gasto', 'Railway Pro', NULL, 15000, '2026-03-01', 'Hosting backend API — marzo'),

-- ABRIL 2026
('V-1011', 'venta', 'Cadena Li-Cor Express (3 sucursales)', 'a1000001-0000-0000-0000-000000000009', 1728000, '2026-04-05', '72 cajas mixtas Savage x24 ($24.000 c/u) — Acuerdo cadena 3 locales'),
('V-1012', 'venta', 'Minimarket Don Pancho — Valparaíso', 'a1000001-0000-0000-0000-000000000002', 408000, '2026-04-10', '17 cajas Savage Passion Fruit x24 ($24.000 c/u) — Recompra'),
('V-1013', 'venta', 'Botillería Los Hermanos — Villa Alemana', 'a1000001-0000-0000-0000-000000000011', 336000, '2026-04-15', '14 cajas Savage Exotic Soursop x24 ($24.000 c/u)'),
('G-1008', 'gasto', 'Frutícola del Maule S.A.', NULL, 450000, '2026-04-02', 'Pulpa de mango, maracuyá y guanábana — 600 kg'),
('G-1009', 'gasto', 'Transportes Rápidos Santiago S.A.', NULL, 185000, '2026-04-12', 'Flete Santiago → V Región — 103 cajas (3 destinos)'),
('G-1010', 'gasto', 'Diseño y Branding — Freelancer', NULL, 250000, '2026-04-08', 'Actualización etiquetas latas + diseño material ferias'),
('P-1002', 'perdida', 'Devolución — Almacén El Rincón', NULL, 48000, '2026-04-20', '2 cajas Pineapple devueltas por defecto de impresión en latas'),

-- MAYO 2026
('V-1014', 'venta', 'Supermercado Fresh Market — Providencia', 'a1000001-0000-0000-0000-000000000006', 1440000, '2026-05-05', '60 cajas mixtas Savage x24 ($24.000 c/u) — Reposición mensual cadena'),
('V-1015', 'venta', 'Bar Rooftop Bellavista', 'a1000001-0000-0000-0000-000000000005', 480000, '2026-05-10', '20 cajas Savage Passion Fruit x24 ($24.000 c/u) — Evento terraza'),
('V-1016', 'venta', 'Distribuidora Reñaca SpA', 'a1000001-0000-0000-0000-000000000003', 1080000, '2026-05-16', '45 cajas mixtas Savage x24 ($24.000 c/u) — Pedido temporada alta'),
('V-1017', 'venta', 'Botillería La Esquina — Viña del Mar', 'a1000001-0000-0000-0000-000000000001', 600000, '2026-05-22', '25 cajas mixtas Savage x24 ($24.000 c/u)'),
('G-1011', 'gasto', 'Envases Plásticos del Pacífico Ltda.', NULL, 1040000, '2026-05-03', 'Compra latas aluminio impresas — lote mayo (4.000 unidades)'),
('G-1012', 'gasto', 'Arriendo bodega industrial — Viña del Mar', NULL, 320000, '2026-05-01', 'Arriendo mensual bodega 80m² con frío'),
('G-1013', 'gasto', 'Frutícola del Maule S.A.', NULL, 560000, '2026-05-07', 'Pulpa frutal mix — 750 kg para producción mayo'),
('G-1014', 'gasto', 'Publicidad Instagram Ads', NULL, 180000, '2026-05-12', 'Campaña pagada "Savage Summer" — 30 días alcance V Región'),

-- JUNIO 2026
('V-1018', 'venta', 'Cadena Li-Cor Express (3 sucursales)', 'a1000001-0000-0000-0000-000000000009', 2016000, '2026-06-03', '84 cajas mixtas Savage x24 ($24.000 c/u) — Reposición trimestral'),
('V-1019', 'venta', 'Licorería Central — Santiago Centro', 'a1000001-0000-0000-0000-000000000004', 720000, '2026-06-10', '30 cajas Savage Creamy Mango x24 ($24.000 c/u)'),
('V-1020', 'venta', 'Tienda Gourmet Vitacura', 'a1000001-0000-0000-0000-000000000010', 384000, '2026-06-15', '16 cajas mixtas Savage x24 ($24.000 c/u) — Pedido de prueba'),
('V-1021', 'venta', 'Minimarket Don Pancho — Valparaíso', 'a1000001-0000-0000-0000-000000000002', 504000, '2026-06-20', '21 cajas Savage Exotic Soursop x24 ($24.000 c/u)'),
('G-1015', 'gasto', 'Arriendo bodega industrial — Viña del Mar', NULL, 320000, '2026-06-01', 'Arriendo mensual bodega — junio'),
('G-1016', 'gasto', 'Contador Externo — Honorarios', NULL, 180000, '2026-06-05', 'Asesoría contable y tributaria mensual — junio'),
('G-1017', 'gasto', 'Transportes Rápidos Santiago S.A.', NULL, 210000, '2026-06-08', 'Flete Santiago → V Región + RM — 121 cajas'),
('P-1003', 'perdida', 'Merma producción — Lote defectuoso', NULL, 168000, '2026-06-12', '7 cajas Creamy Mango descartadas por fecha de pulpa vencida antes de envasado');
