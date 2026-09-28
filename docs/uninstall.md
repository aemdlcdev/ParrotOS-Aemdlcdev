# Desinstalación

La desinstalación usa `managed.tsv`. Un archivo completo solo se elimina si conserva el checksum instalado; si fue modificado se conserva y se avisa.

Los bloques de integración Zsh se retiran por sus marcadores. Los backups y archivos de estado se mantienen para recuperación.

Los paquetes no se retiran por defecto. `--purge-packages` actúa únicamente sobre paquetes que el manifiesto registró como añadidos por este proyecto.

