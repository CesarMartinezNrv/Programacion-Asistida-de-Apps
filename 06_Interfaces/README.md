# Comunidad USFQ

Aplicación Flutter de registro, inicio de sesión y consulta de perfiles compartidos mediante Supabase. Incluye un endpoint FastAPI opcional para crear usuarios desde un servidor.

## Arquitectura

La dirección de dependencias es `presentation -> domain <- data`:

- `domain`: entidades, contratos y el caso de uso de registro; no depende de Flutter ni Supabase.
- `data`: implementaciones de los contratos con Supabase.
- `presentation`: pantallas y estado con Provider; solo conoce los contratos del dominio.
- `main.dart`: punto de composición de las implementaciones concretas.

## Configurar Supabase

1. Ejecuta [`supabase/configuracion.sql`](supabase/configuracion.sql) en el SQL Editor de Supabase.
2. Desactiva **Confirm email** en Authentication > Sign In / Providers > Email para esta práctica.
3. Copia `.env.example` como `.env` y coloca la URL y la clave **publicable** del proyecto:

```env
SUPABASE_URL=https://TU_PROYECTO.supabase.co
SUPABASE_KEY=TU_CLAVE_PUBLICABLE
```

El archivo `.env` está ignorado por Git. Nunca coloques la clave secreta en la aplicación Flutter.

## Ejecutar Flutter

```bash
flutter pub get
flutter run
```

Sin credenciales válidas, la aplicación muestra una pantalla de configuración pendiente en vez de cerrarse con un error.

## Ejecutar FastAPI

Dentro de `api_usuarios`, crea un entorno virtual, instala las dependencias y copia `.env.example` como `.env`. En ese archivo usa la clave **secreta** de Supabase.

```bash
python -m venv .venv
pip install -r requirements.txt
uvicorn main:app --reload
```

La documentación interactiva queda disponible en `http://127.0.0.1:8000/docs` y el endpoint de comprobación en `GET /salud`.

## Verificación

```bash
flutter analyze
flutter test
```
