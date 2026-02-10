# 🚀 Guía de Implementación — ConciliaSII

Tiempo estimado: 20-30 minutos. No necesitas saber programar.

---

## Paso 1: Crear cuenta en Supabase (Base de datos gratuita)

1. Ve a **https://supabase.com** y crea una cuenta (puedes usar GitHub o email)
2. Haz clic en **"New Project"**
3. Completa:
   - **Name**: `conciliasii`
   - **Database Password**: elige una contraseña segura y guárdala
   - **Region**: `South America (São Paulo)`
4. Espera ~2 minutos mientras se crea

## Paso 2: Crear las tablas

1. En tu proyecto Supabase, haz clic en **"SQL Editor"** en el menú izquierdo
2. Haz clic en **"New query"**
3. Copia y pega TODO el contenido del archivo `sql/schema.sql` que viene incluido
4. Haz clic en **"Run"** (o Ctrl+Enter)
5. Deberías ver "Success. No rows returned" — eso está bien, las tablas se crearon

## Paso 3: Configurar la autenticación

1. En Supabase, ve a **Authentication** → **Providers** en el menú izquierdo
2. Verifica que **Email** esté habilitado (viene por defecto)
3. **OPCIONAL pero recomendado para pruebas**: Ve a **Authentication** → **Settings** y desactiva "Confirm email" para no tener que verificar email durante desarrollo. Para producción déjalo activado.

## Paso 4: Obtener las credenciales de Supabase

1. En Supabase, ve a **Settings** → **API** (menú izquierdo)
2. Copia estos dos valores (los vas a necesitar):
   - **Project URL**: algo como `https://abcdefgh.supabase.co`
   - **anon public key**: una cadena larga que empieza con `eyJ...`

## Paso 5: Subir a Vercel (Hosting gratuito con HTTPS)

### Opción A: Desde GitHub (recomendada)

1. Crea una cuenta en **https://github.com** si no tienes
2. Crea un nuevo repositorio llamado `conciliasii`
3. Sube todos los archivos de la carpeta del proyecto:
   - `public/index.html`
   - `vercel.json`
   - `sql/schema.sql`
4. Ve a **https://vercel.com** y crea cuenta con tu GitHub
5. Haz clic en **"Add New" → "Project"**
6. Selecciona tu repositorio `conciliasii`
7. Haz clic en **"Deploy"**
8. En ~30 segundos tendrás tu URL: `https://conciliasii.vercel.app` (o similar)

### Opción B: Desde la terminal (si tienes Node.js)

```bash
# Instalar Vercel CLI
npm install -g vercel

# Entrar a la carpeta del proyecto
cd conciliasii

# Desplegar
vercel

# Seguir las instrucciones en pantalla
# Al final te dará tu URL pública
```

## Paso 6: Configurar la app

1. Abre tu app en la URL de Vercel (ej: `https://conciliasii.vercel.app`)
2. Verás la pantalla de login, pero primero necesitas configurar Supabase
3. La primera vez, la app te mostrará campos para ingresar:
   - **Supabase URL**: pega la Project URL del Paso 4
   - **Supabase Anon Key**: pega la anon key del Paso 4
4. Haz clic en "Guardar Configuración"

> **Nota**: Estas credenciales se guardan en tu navegador (localStorage). Son seguras porque la "anon key" solo permite acceso autenticado gracias al Row Level Security (RLS) que configuramos en el schema.

## Paso 7: Crear tu cuenta y empezar a usar

1. En la pantalla de login, ve a **"Registrarse"**
2. Ingresa tu email y una contraseña
3. Si activaste confirmación de email, revisa tu bandeja
4. Inicia sesión y ¡listo!

---

## 🔒 Seguridad

La app tiene varias capas de seguridad:

- **HTTPS**: Vercel sirve todo por HTTPS automáticamente
- **Autenticación**: Login con email/contraseña vía Supabase Auth
- **Row Level Security (RLS)**: Cada usuario solo puede ver SUS propios datos en la base de datos. Esto se controla a nivel de PostgreSQL, no de la app
- **Datos locales**: Los archivos CSV se procesan 100% en tu navegador, nunca se suben a ningún servidor. Solo los resultados de la conciliación se guardan en Supabase

## 📱 Acceso

- Funciona en cualquier navegador moderno (Chrome, Firefox, Edge, Safari)
- Es responsive: funciona en celular y tablet
- Puedes acceder desde cualquier dispositivo con tu mismo login

## 💡 Tips

- **Dominio personalizado**: En Vercel puedes conectar tu propio dominio (ej: `conciliacion.miempresa.cl`) gratuitamente
- **Respaldos**: Supabase hace respaldos automáticos diarios en el plan gratuito
- **Límites del plan gratuito**: 500MB de base de datos, 50,000 usuarios — más que suficiente para uso personal/PYME

---

## Estructura de archivos

```
conciliasii/
├── public/
│   └── index.html          ← La aplicación completa
├── sql/
│   └── schema.sql           ← Script para crear las tablas
├── vercel.json               ← Configuración de Vercel
└── GUIA_IMPLEMENTACION.md    ← Este archivo
```
