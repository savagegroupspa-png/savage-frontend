# Configuración de Supabase para el Panel /admin

Sigue estos pasos en tu consola de Supabase (https://supabase.com) para configurar la base de datos y almacenamiento requeridos por el panel administrativo.

---

## 1. Crear Tablas

Ve a la sección **SQL Editor** de Supabase, abre una nueva consulta y ejecuta el siguiente código SQL:

```sql
-- ═══════════════════════════════════════════════════
-- TABLA: clientes
-- ═══════════════════════════════════════════════════
create table clientes (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default now(),
  nombre text not null,
  rut text,
  tipo text check (tipo in ('distribuidor', 'local', 'restaurant', 'cadena', 'otro')),
  telefono text,
  email text,
  direccion text,
  ciudad text,
  notas text
);

alter table clientes enable row level security;

create policy "Lectura clientes autenticados"
on clientes for select to authenticated using (true);

create policy "Inserción clientes autenticados"
on clientes for insert to authenticated with check (true);

create policy "Actualización clientes autenticados"
on clientes for update to authenticated using (true);

create policy "Eliminación clientes autenticados"
on clientes for delete to authenticated using (true);

-- ═══════════════════════════════════════════════════
-- TABLA: transacciones
-- ═══════════════════════════════════════════════════
create table transacciones (
  id uuid default gen_random_uuid() primary key,
  created_at timestamptz default timezone('utc'::text, now()) not null,
  folio text,
  tipo text not null check (tipo in ('venta', 'gasto', 'perdida')),
  cliente_proveedor text not null,
  cliente_id uuid references clientes(id),
  monto numeric not null check (monto >= 0),
  fecha date not null,
  descripcion text,
  archivo_url text
);

alter table transacciones enable row level security;

create policy "Lectura transacciones autenticados"
on transacciones for select to authenticated using (true);

create policy "Inserción transacciones autenticados"
on transacciones for insert to authenticated with check (true);

create policy "Eliminación transacciones autenticados"
on transacciones for delete to authenticated using (true);
```

---

## 2. Crear Bucket de Almacenamiento para Facturas

1. Ve a la sección **Storage** en Supabase.
2. Haz clic en **New Bucket**.
3. Nómbralo exactamente `facturas`.
4. Elige que sea un **Public Bucket**.
5. Ve a **Policies** y crea políticas para que usuarios autenticados puedan subir (Insert), leer (Select) y eliminar (Delete).

---

## 3. Crear Usuario Administrador

1. Ve a **Authentication** → **Users**.
2. Haz clic en **Add User** → **Create User**.
3. Ingresa el correo electrónico y contraseña del administrador.

---

## 4. Configurar Variables de Entorno (.env)

Crea un archivo `.env` en la raíz de `savage_frontend/`:

```env
PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
PUBLIC_SUPABASE_ANON_KEY=tu-anon-key-de-supabase
```
