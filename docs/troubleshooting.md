# Resolución de problemas

1. Ejecuta `doctor` desde una terminal del usuario.
2. Revisa el último log en `~/.local/state/aemdlc-environment/logs/`.
3. Comprueba `polybar --list-monitors` y `pgrep -a bspwm`.
4. Valida configuraciones antes de reintentar: `bash -n ~/.config/bspwm/bspwmrc`.
5. Repite el instalador con `--dry-run` para ver el plan.

No corrijas problemas cambiando repositorios de Parrot o copiando paquetes de otra versión de Debian.

