# Fase 1 — Inventario funcional clean-room

Estado: completada para análisis; no se ha iniciado la implementación.

## Alcance y trazabilidad

Este documento describe comportamientos observables del proyecto de referencia sin reutilizar su código, documentación, mensajes, configuraciones ni recursos gráficos.

- Referencia analizada: `https://github.com/Balthael/ParrotEntorno`
- Instantánea local consultada: commit `44dfcbac02aef7f4a0e425c98705b01c678b4789`
- Fecha de esa instantánea: 2025-10-09
- Plataforma objetivo nueva: Parrot OS 7.3, Debian 13 (Trixie), amd64, systemd y sesión X11
- Directorio del futuro proyecto: `C:\Users\aeste\Documents\GitHub\ParrotOS Aemdlcdev`

La inspección se limitó a identificar funciones, programas, integración y apariencia. La futura implementación se escribirá desde cero y se contrastará con documentación oficial o paquetes de Parrot/Debian.

## Inventario principal

| Funcionalidad observada o solicitada | Componente | Posible origen conceptual | Implementación nueva prevista |
|---|---|---|---|
| Sesión gráfica seleccionable desde el gestor de acceso | BSPWM + archivo XSession del paquete | BSPWM/Debian | Instalar el paquete oficial, verificar `/usr/share/xsessions/bspwm.desktop` y no sustituir KDE/MATE ni el display manager. |
| Gestión de ventanas en mosaico | BSPWM | Upstream BSPWM | Crear `bspwmrc` propio a partir de la documentación; valores, reglas y nombres configurables. |
| Diez escritorios virtuales | BSPWM | Función estándar | Declarar diez escritorios con nombres originales elegibles mediante un archivo de ajustes del proyecto. |
| Bordes, separación y modo monocle | BSPWM | Función estándar | Definir una apariencia nueva mediante variables de tema; sin trasladar valores del proyecto analizado. |
| Reglas por aplicación | BSPWM | Función estándar | Proveer reglas mínimas y documentadas, evitando supuestos sobre aplicaciones no instaladas. |
| Foco, intercambio, movimiento y estados de ventanas | BSPC + SXHKD | Ejemplos oficiales de BSPWM/SXHKD | Diseñar un mapa de teclas propio y coherente, con validación de colisiones. |
| Preselección direccional y proporciones | BSPC + SXHKD | Función estándar de BSPWM | Exponer atajos nuevos basados en la interfaz documentada de `bspc`. |
| Redimensionado sensible a ventana flotante o en mosaico | Script auxiliar | Lógica personalizada genérica | Reescribir desde cero con validación de dirección, códigos de salida y pasos configurables. |
| Terminal por atajo | Kitty + SXHKD | Función estándar | Ejecutar el terminal configurado mediante una variable central; Kitty será el predeterminado. |
| Lanzador de aplicaciones | Rofi + SXHKD | Upstream Rofi | Tema Rasi nuevo y modo `drun`; sin copiar temas del repositorio de referencia. |
| Navegación entre escritorios y envío de ventanas | BSPC + SXHKD | Función estándar | Mapa de teclas propio para escritorios 1–10. |
| Captura de pantalla interactiva | Flameshot | Upstream Flameshot | Atajo propio y arranque opcional; detectar si existe una sesión gráfica compatible. |
| Bloqueo de pantalla | i3lock o alternativa empaquetada | Upstream/Debian | Usar el paquete oficial y una pantalla de bloqueo propia; no depender de `i3lock-fancy` ni de fuentes/rutas incrustadas. |
| Fondo de escritorio | Feh | Upstream/Debian | Incluir como máximo un fondo original o con licencia explícita y permitir una ruta del usuario. |
| Compatibilidad con aplicaciones Java en BSPWM | Variable de entorno X11 | Práctica genérica de WM no reparenting | Aplicar solo en el entorno de la sesión BSPWM y documentar su propósito. |
| Compatibilidad con aplicaciones que esperan un WM conocido | `wmname` | Herramienta X11 genérica | Hacerla opcional y activarla únicamente si una prueba demuestra que sigue siendo necesaria. |
| Integración de herramientas de VMware | `vmware-user-suid-wrapper` | VMware Tools | Detectar el ejecutable antes de lanzarlo; no convertir VMware en dependencia obligatoria. |
| Composición, transparencias y esquinas | Picom | Upstream Picom | `picom.conf` propio compatible con Picom 12.x, con backend y exclusiones conservadores. |
| Barra superior en secciones visuales tipo “píldora” | Polybar | Upstream Polybar + diseño personalizado | Una barra organizada por includes y módulos, adaptable a resolución y monitor; no replicar geometrías rígidas. |
| Escritorio activo | Módulo BSPWM/xworkspaces de Polybar | Upstream Polybar | Usar el módulo adecuado y etiquetas propias. |
| Título de ventana | Polybar | Upstream Polybar | Módulo opcional con longitud máxima y escape seguro. |
| CPU | Polybar | Upstream Polybar | Módulo interno con intervalo y umbrales configurables. |
| Memoria | Polybar | Upstream Polybar | Módulo interno con formato propio. |
| Volumen | Polybar + ALSA/PulseAudio/PipeWire | Upstream Polybar | Detectar el backend disponible en Parrot 7.3 y preferir el módulo compatible; no fijar una tarjeta. |
| Batería | Polybar + `/sys/class/power_supply` | Linux/Polybar | Mostrar el módulo solo si se detecta una batería; descubrir nombres de batería y adaptador. |
| Reloj y fecha | Polybar | Upstream Polybar | Módulo interno con formato configurable y acción opcional. |
| Estado de red | Polybar + iproute2 | Linux estándar | Detectar automáticamente ruta e interfaz activas, sin nombres como `wlp2s0`, `eth0` o `net0` codificados. |
| IP local Ethernet/Wi-Fi | Script propio de Polybar | Funcionalidad genérica | Consultar `ip -json` o salida estable de iproute2; excluir loopback, seleccionar ruta predeterminada y manejar varias interfaces. |
| Estado/IP de VPN | Script propio de Polybar | Flujo pentest genérico | Detectar interfaces configurables (`tun*`, `tap*`, `wg*`) y su IPv4/IPv6; no depender de `ifconfig`. |
| Objetivo actual de laboratorio | Utilidad CLI + módulo Polybar | Flujo pentest genérico | Crear comandos `settarget`, `showtarget` y `cleartarget`; almacenar estado bajo `~/.local/state/<proyecto>/`. |
| Validación del objetivo | Utilidad CLI | Nueva lógica propia | Aceptar IP válida y nombre limitado; escritura atómica, permisos de usuario y mensajes de error claros. |
| Menú de energía | Rofi + systemd/login manager | Rofi/systemd | Menú propio para bloquear, suspender, cerrar sesión, reiniciar y apagar; confirmar acciones destructivas. |
| Cambio de tema oscuro/claro | Polybar/Rofi/Kitty/Picom | Mejora solicitada | Tema central declarativo y comando de selección; regenerar enlaces controlados sin duplicar configuraciones. |
| Terminal con pestañas, divisiones y navegación | Kitty | Upstream Kitty | Configuración propia basada en la sintaxis actual; fuente, tamaño y opacidad configurables. |
| Shell interactiva avanzada | Zsh | Upstream Zsh/Debian | Archivo pequeño que cargue módulos propios desde `~/.config`; conservar y respaldar la configuración existente. |
| Prompt enriquecido | Powerlevel10k | Upstream Powerlevel10k | Instalar una versión/tag fijado desde el repositorio oficial y generar una configuración original. |
| Framework de shell | Oh My Zsh | Upstream Oh My Zsh | Componente opcional, nunca instalado mediante `curl | sh`; clonado a versión fijada si el usuario lo selecciona. |
| Sugerencias y resaltado en Zsh | Paquetes de Debian | Debian/upstream | Preferir `zsh-autosuggestions` y `zsh-syntax-highlighting` desde APT cuando estén disponibles. |
| Historial y búsqueda difusa | fzf + Zsh | Upstream fzf/Debian | Instalar `fzf` por APT y cargar la integración distribuida por Debian; evitar un clon duplicado por usuario/root. |
| Listado y visualización mejorados | `lsd`/`eza`, `bat` | Proyectos upstream/Debian | Preferir paquetes de Parrot/Debian; aliases opt-in que no oculten herramientas POSIX en scripts. |
| Información del sistema en terminal | Fastfetch | Upstream/Debian | Sustituir Neofetch, ya obsoleto, por `fastfetch` empaquetado; arranque opcional para no ralentizar cada shell. |
| Editor moderno | Neovim | Upstream Neovim/Debian | Preferir paquete APT de Trixie; permitir descarga oficial fijada y verificada solo si se exige una versión superior. |
| Configuración de Neovim | Neovim Lua | Upstream Neovim | Configuración modular original y mínima; plugins declarados y fijados, sin copiar NvChad ni empaquetar su runtime. |
| Copiar resultados al portapapeles X11 | `xclip` o `xsel` | Debian/X11 | Dependencia opcional para utilidades pentest; comprobar disponibilidad antes de usarla. |
| Preparar carpetas de trabajo pentest | Utilidad shell | Flujo genérico | Comando propio idempotente con nombres configurables, comprobación de destino y sin sobrescrituras. |
| Extraer puertos de resultados Nmap | Utilidad shell | Flujo genérico | Parser nuevo con validación de archivo y formatos conocidos; no usar expresiones del proyecto analizado. |
| Lanzar VPN de laboratorio | OpenVPN/NetworkManager | Upstream + Parrot | Comando opcional que reciba un perfil, valide permisos y no contenga rutas personales. |
| Soporte HTB y TryHackMe | Scripts de estado | Mejora solicitada | Perfiles de VPN/objetivo configurables, sin credenciales y con etiquetas neutrales. |
| Fuentes con iconos | Nerd Fonts | Upstream Nerd Fonts | Descargar una familia concreta desde un release fijado, verificar checksum publicado e instalarla por usuario. |
| Selector de componentes | Instalador modular | Nueva arquitectura | Menú completo/WM/shell/herramientas/configuración, más flags no interactivos para automatización. |
| Detección del sistema | `/etc/os-release` | Freedesktop/systemd | Leer `ID`, `ID_LIKE`, `VERSION_ID` y `VERSION_CODENAME`; aceptar Parrot 7.x, ofrecer Debian 13 experimental y rechazar el resto por defecto. |
| Detección del usuario real | NSS + entorno sudo | Linux estándar | Resolver UID, usuario y home de forma robusta; abortar si la identidad es ambigua. |
| Instalación de paquetes | APT/dpkg-query/apt-cache | Debian/Parrot | Comprobar instalación y candidato antes de instalar; agrupar operaciones y registrar resultados. |
| Instalación desde upstream | Git/releases oficiales | Upstream | Solo cuando APT no cubra el requisito; tag fijado, HTTPS, verificación y separación explícita de la ruta APT. |
| Copias de seguridad | Módulo común | Nueva lógica propia | Backup con fecha/manifiesto antes de cada archivo gestionado; no tocar archivos ajenos sin confirmación. |
| Reejecución segura | Instalador | Nueva lógica propia | Operaciones idempotentes, estado gestionado y actualización de bloques delimitados sin duplicarlos. |
| Desinstalación | Desinstalador + manifiesto | Nueva lógica propia | Quitar solo archivos creados por el proyecto; restaurar backups cuando sea seguro y no eliminar paquetes preexistentes. |
| Logs y diagnóstico | Biblioteca común | Nueva lógica propia | Logs por nivel, resumen final, archivo de sesión sin secretos y manejador de errores con contexto. |
| Instalación como root segura | Biblioteca común | Nueva lógica propia | Privilegios mínimos: tareas del usuario con su UID y tareas de sistema mediante función controlada. |

## Resultado visual observado

El resultado de referencia usa un escritorio oscuro con fondo de alto contraste y una Polybar superior fragmentada en cápsulas: lanzador e IP local a la izquierda, VPN a continuación, escritorios centrados, objetivo hacia la derecha y control de energía al extremo. Las ventanas presentan separación, bordes coloreados, esquinas redondeadas y transparencia en Kitty.

La equivalencia nueva conservará esa jerarquía visual y densidad de información, pero tendrá paleta, iconografía, tipografía, fondo, medidas, mensajes y composición propios. No se reutilizará ninguna captura ni imagen observada.

## Programas y dependencias detectados

### Núcleo que se conserva

- BSPWM, SXHKD, Polybar, Picom, Kitty, Rofi, Zsh, Powerlevel10k, Neovim, fzf y Flameshot.
- Utilidades de integración: `iproute2`, Feh, i3lock, fontconfig y herramientas X11.
- Complementos opcionales: `bat`, `lsd` o `eza`, Fastfetch, OpenVPN y portapapeles X11.

### Elementos presentes en la referencia que no se trasladarán

- Binarios de Neovim incluidos dentro del repositorio.
- Paquetes `.deb` almacenados para `bat` y `lsd`.
- Colecciones de fuentes copiadas al repositorio.
- Fondos, capturas, iconos y otros recursos gráficos de la referencia.
- Configuración completa de Powerlevel10k, Zsh, Kitty, Polybar, Rofi, Picom, BSPWM o SXHKD.
- Plugin de `sudo` empaquetado en el repositorio.
- Lanzadores con rutas personales para Telegram, Discord, VirtualBox, Obsidian o perfiles VPN.
- Cualquier lanzador de software de pago modificado, loader, keygen o agente Java no oficial.
- Dependencia de un directorio localizado como `Descargas`/`Downloads`.
- `i3lock-fancy` como clon no fijado; la función de bloqueo se resolverá con software empaquetado.
- Repositorio `blue-sky`, porque no es necesario para conseguir las funciones nucleares descritas.

## Adecuación a Parrot OS 7.3 / Debian 13

Comprobaciones documentales iniciales:

- Parrot 7.3 está basado en Debian 13 y mantiene `parrot-upgrade` como vía oficial de actualización.
- Debian 13 ofrece paquetes para BSPWM 0.9.10, SXHKD 0.6.2, Polybar 3.7.2, Picom 12.5, Kitty 0.41.1, Rofi 1.7.5, Flameshot 12.1, Zsh 5.9, fzf 0.60.3 y Neovim.
- El paquete BSPWM de Debian ya depende de SXHKD e instala una entrada XSession; por ello no hay motivo inicial para compilar ambos.
- Picom y Polybar también están empaquetados; se preferirá APT antes de considerar compilación.
- Fastfetch está disponible en Trixie y es el reemplazo previsto para Neofetch.
- `bat` y `lsd` existen en Trixie; no se distribuirán paquetes Debian propios.

La disponibilidad definitiva se comprobará durante la instalación con los repositorios activos de la máquina Parrot, no mediante una lista asumida.

## Comportamientos incompatibles u obsoletos que se corrigen

| Comportamiento observado | Riesgo | Decisión clean-room |
|---|---|---|
| Alterar la primera línea de `/etc/apt/sources.list` | Puede romper repositorios de Parrot | Nunca modificar fuentes APT automáticamente. Solo validar y reportar errores. |
| Ejecutar actualización completa sin una elección separada | Cambios de sistema inesperados | `apt update` explícito; actualización completa opcional y documentada. |
| Compilar ramas por defecto de varios proyectos | Resultado no reproducible | APT-first; si hace falta upstream, tag estable fijado. |
| Instalar BSPWM tanto compilado como por APT | Conflicto de rutas y versiones | Elegir una única estrategia, por defecto APT. |
| Compilar un fork de Picom abandonando upstream principal | Mantenimiento y seguridad | Usar `yshui/picom` o el paquete de Parrot/Debian. |
| Usar `ifconfig` para VPN | Herramienta antigua y dependencia extra | Usar iproute2 con manejo de múltiples interfaces. |
| Interfaces, batería, monitor y resolución fijos | Falla en otros equipos | Detección dinámica y archivo de overrides. |
| Sobrescribir `.zshrc` y configuración de root | Pérdida de datos y escalada de impacto | Configurar solo al usuario objetivo, con backup; root será opt-in y separado. |
| Enlazar la configuración de root a la del usuario | Frontera de seguridad incorrecta | Prohibido; configuraciones independientes. |
| Cambiar shells y cerrar la sesión de forma forzada | Interrupción destructiva | Pedir confirmación y explicar que el cambio aplica en el siguiente inicio de sesión. |
| Copiar fuentes y binarios a rutas globales | Falta de trazabilidad/licencia | Descarga oficial verificada o paquete APT; instalación de fuente por usuario. |
| Menú de energía sin confirmación | Apagados accidentales | Confirmación para apagar/reiniciar y comprobación de sesión. |
| Estado de target guardado dentro de configuración ejecutable | Mezcla de código y estado | XDG state bajo `~/.local/state/<proyecto>/`. |
| Script monolítico sin modo estricto | Recuperación difícil ante fallos | Librerías modulares, `set -Eeuo pipefail`, trampas y resumen de cambios. |
| Rutas y nombres de usuario incorporados | No portable y filtra datos | Resolver identidad mediante NSS y variables XDG. |

## Fuentes upstream y oficiales de referencia

- Parrot 7.3: https://parrotsec.org/blog/2026-06-30-parrot-7.3-release-notes/
- Migración de Parrot 7 / Debian 13: https://www.parrotsec.org/docs/configuration/upgrade-from-lorykeet/
- Paquetes Debian 13: https://packages.debian.org/trixie/
- BSPWM: https://github.com/baskerville/bspwm
- SXHKD: https://github.com/baskerville/sxhkd
- Polybar: https://github.com/polybar/polybar
- Picom: https://github.com/yshui/picom
- Kitty: https://sw.kovidgoyal.net/kitty/
- Rofi: https://github.com/davatorium/rofi
- Zsh: https://www.zsh.org/
- Powerlevel10k: https://github.com/romkatv/powerlevel10k
- Oh My Zsh: https://github.com/ohmyzsh/ohmyzsh
- Neovim: https://github.com/neovim/neovim
- fzf: https://github.com/junegunn/fzf
- Flameshot: https://flameshot.org/
- Nerd Fonts: https://github.com/ryanoasis/nerd-fonts

## Criterios de aceptación derivados para fases posteriores

- La sesión BSPWM coexistirá con el escritorio de Parrot y será seleccionable en el login.
- Ninguna operación cambiará repositorios APT de Parrot.
- Cada archivo sustituido tendrá backup y propietario correctos.
- Todos los módulos Polybar funcionarán sin nombres de hardware codificados.
- El target y las IP mostrarán estados vacíos de forma limpia.
- El instalador completo y cada instalación selectiva podrán repetirse.
- La desinstalación distinguirá recursos propios de paquetes o configuraciones preexistentes.
- El repositorio no contendrá binarios, paquetes `.deb`, fuentes ni imágenes procedentes de la referencia.
- La futura auditoría comparará funciones y pruebas, no texto ni estructura de código.

## Decisiones pendientes antes de la Fase 2

Los campos de marca proporcionados originalmente siguen como marcadores. Antes de redactar branding definitivo habrá que confirmar:

- nombre público del proyecto (la carpeta sugiere `ParrotOS Aemdlcdev`, pero no se asume como marca final);
- nombre o seudónimo del autor;
- nombre/URL del repositorio final;
- personalizaciones deseadas para paleta, nombres de escritorios y atajos.

Estas decisiones no impiden cerrar el inventario funcional, pero sí condicionan la arquitectura de temas, nombres XDG y documentación de la Fase 2.
