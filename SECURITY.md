# Seguridad

## Reportar un problema

No publiques credenciales, perfiles VPN ni información de objetivos en un issue. Utiliza el canal privado que figure en el repositorio público cuando esté disponible.

## Modelo de confianza

- APT usa exclusivamente los repositorios ya configurados por Parrot.
- Las descargas externas se limitan a upstreams declarados y HTTPS.
- No se ejecutan scripts remotos mediante tuberías.
- El instalador no almacena contraseñas, tokens ni claves.
- Los cambios privilegiados se reducen a paquetes y archivos expresamente documentados.

Revisa siempre el plan con `--dry-run` y conserva un snapshot si pruebas en una VM.

