# Imagen base liviana y oficial de Nginx
FROM nginx:alpine

LABEL org.opencontainers.image.title="reserva-horas-web" \
      org.opencontainers.image.description="Servicio web estático de reserva de horas médicas (proyecto DevOps IACC)" \
      org.opencontainers.image.version="1.0.0"

# Configuración propia de Nginx (cabeceras de seguridad y /health)
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

# Contenido estático del sitio
COPY src/ /usr/share/nginx/html/

EXPOSE 80

# Docker revisa periódicamente que el servicio responda
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -q -O /dev/null http://127.0.0.1/health || exit 1
