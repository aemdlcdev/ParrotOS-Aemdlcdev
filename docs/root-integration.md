# Integración de root

La instalación completa prepara una shell elevada coherente sin ejecutar como root archivos modificables por el usuario del escritorio.

## Comportamiento

- `sudo su` comienza en Bash y un bloque administrado transfiere la sesión interactiva a Zsh.
- `/root/.zshrc` carga únicamente `/etc/aemdlc-environment/zsh/root-init.zsh`.
- Powerlevel10k y Oh My Zsh se descargan de nuevo, como root, en `/usr/local/share/aemdlc-environment/` usando las mismas revisiones fijadas que la instalación normal.
- Los ejecutables expuestos a root son copias root-owned bajo `/usr/local/bin` o `/usr/local/lib/aemdlc-environment`.
- No se modifica el shell registrado para root en `/etc/passwd`.

## Estado target compartido

`/usr/local/bin/targetctl` es un lanzador privilegiado pequeño. Cuando su UID es cero, valida el usuario registrado durante la instalación y usa `runuser` para ejecutar la implementación como ese usuario. De esta forma, el archivo target continúa perteneciendo al usuario y Polybar ve los cambios.

## Rutas autorizadas

El instalador usa listas cerradas para aceptar exclusivamente:

- `/etc/aemdlc-environment/`;
- `/usr/local/lib/aemdlc-environment/`;
- `/usr/local/share/aemdlc-environment/`;
- los comandos declarados en `/usr/local/bin`;
- los bloques delimitados del proyecto en `/root/.bashrc` y `/root/.zshrc`.

Los archivos existentes se respaldan bajo `/root/.local/state/aemdlc-environment/backups/`. La desinstalación comprueba por separado archivos, bloques compartidos y árboles upstream; rechaza entradas del manifiesto que no coincidan con la lista cerrada.

## Límites

Las aplicaciones del escritorio (`Polybar`, `Rofi`, el selector de temas y el menú de energía) siguen perteneciendo al usuario gráfico. No deben iniciarse desde la shell root.
