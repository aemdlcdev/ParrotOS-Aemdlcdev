# Configuración

Los archivos bajo `config/` son la fuente del proyecto. El instalador los despliega bajo XDG y crea backups antes de cambiar un destino existente.

Variables útiles:

| Variable | Uso |
|---|---|
| `AEM_TARGET_USER` | Usuario objetivo cuando se ejecuta como root directo. |
| `AEM_WALLPAPER` | Fondo local que cargará Feh. |
| `AEM_VPN_PATTERNS` | Prefijos de interfaces VPN separados por espacios. |
| `AEM_RESIZE_STEP` | Píxeles usados al redimensionar. |
| `XDG_CONFIG_HOME` | Raíz alternativa de configuración. |
| `XDG_STATE_HOME` | Raíz alternativa de estado. |

No edites copias del repositorio para guardar secretos. Los perfiles VPN permanecen fuera del proyecto.

