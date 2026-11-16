# Reserva de Horas Médicas – Proyecto DevOps

Servicio web estático de reserva de horas médicas para una empresa del rubro salud (caso simulado), servido con **Nginx** dentro de un contenedor **Docker** y levantado con **Docker Compose** en el puerto **8080**.

> Proyecto académico, asignatura DevOps (IACC, 2026). El formulario es solo de demostración: no envía ni almacena datos, no usa API ni base de datos.

## Estructura del proyecto

```
reserva-horas-devops/
├── .github/workflows/devops-automation.yml   # Validación automática (complementaria)
├── nginx/default.conf                        # Configuración de Nginx (seguridad y /health)
├── src/
│   ├── index.html                            # Formulario de reserva, datos de atención y estado
│   ├── styles.css                            # Hoja de estilos
│   └── app.js                                # Simula el envío del formulario
├── .env.example                              # Plantilla de variables de entorno (sin secretos)
├── .gitignore                                # Archivos que no se versionan (.env, logs, etc.)
├── Dockerfile                                # Imagen basada en nginx:alpine
├── docker-compose.yml                        # Servicio "web" publicado en el puerto 8080
└── README.md
```

## Requisitos

- Git
- Docker Desktop instalado e iniciado
- Navegador web

## Instalación

```bash
git clone https://github.com/<tu-usuario>/reserva-horas-devops.git
cd reserva-horas-devops
cp .env.example .env        # En Windows (PowerShell): copy .env.example .env
```

El archivo `.env` es opcional: si no existe, Compose usa los valores por defecto (puerto 8080).

## Ejecución

```bash
docker compose up -d --build   # Construye la imagen y levanta el contenedor
```

## Verificación

1. Abrir **http://localhost:8080** en el navegador.
2. Revisar el endpoint de salud: **http://localhost:8080/health** (responde `ok`).
3. Revisar el estado desde la terminal:

```bash
docker compose ps
docker ps
```

## Monitoreo básico

```bash
docker logs reserva-horas-web        # Registros de acceso y errores de Nginx
docker compose logs                  # Logs del servicio definido en Compose
docker stats --no-stream             # Uso de CPU, memoria y red del contenedor
```

También se pueden ver los logs, el estado de salud (healthy) y las métricas en Docker Desktop, sección *Containers*.

## Detener el servicio

```bash
docker compose stop      # Detiene el contenedor sin eliminarlo
docker compose down      # Detiene y elimina contenedor y red
```

## Variables de entorno

| Variable      | Uso                                   | Valor por defecto   |
|---------------|---------------------------------------|---------------------|
| `APP_PORT`    | Puerto local donde se publica el sitio | `8080`              |
| `APP_VERSION` | Etiqueta de la imagen construida       | `1.0.0`             |
| `APP_ENV`     | Nombre del entorno                     | `desarrollo`        |
| `TZ`          | Zona horaria de los logs               | `America/Santiago`  |

## Buenas prácticas de seguridad aplicadas

- **Sin credenciales en el repositorio:** solo se versiona `.env.example` con valores de ejemplo; el `.env` real está en `.gitignore`.
- **Sin datos personales:** el formulario indica que es una demostración y no guarda información.
- **Imagen base oficial y liviana** (`nginx:alpine`), con menos paquetes y menor superficie de ataque.
- **Nginx endurecido:** `server_tokens off` y cabeceras `X-Content-Type-Options`, `X-Frame-Options`, `Referrer-Policy` y `Content-Security-Policy`.
- **Healthcheck** en el Dockerfile y endpoint `/health` para detectar caídas del servicio.
- **Validación automática** en GitHub Actions que falla si alguien sube un archivo `.env`.

## Flujo de trabajo con Git

- `main`: versión estable; los cambios llegan solo por pull request.
- `feature/<descripcion>`: nuevas funcionalidades (ej. `feature/formulario-reserva`).
- `fix/<descripcion>` y `docs/<descripcion>`: correcciones y documentación.
- Commits pequeños con mensajes descriptivos en español.

## Automatización (complementaria)

El workflow `.github/workflows/devops-automation.yml` se ejecuta en cada push o pull request hacia `main`. Verifica que existan los archivos obligatorios y que no se haya subido un `.env`, valida `docker-compose.yml`, construye la imagen, levanta el servicio, comprueba que responde en `localhost:8080` y muestra los logs. No publica la aplicación en servidores externos.
