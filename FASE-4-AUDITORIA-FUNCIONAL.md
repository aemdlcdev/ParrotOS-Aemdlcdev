# Fase 4 — Auditoría comparativa de funcionalidad

Fecha: 2026-09-28

## Leyenda

- **Implementado**: existe lógica o configuración propia y ha pasado comprobación estática.
- **Mejorado**: conserva la finalidad con mayor portabilidad, seguridad o mantenimiento.
- **Pendiente Parrot**: la implementación existe, pero requiere una sesión real Parrot OS 7.3/X11.
- **Excluido**: comportamiento personal, inseguro, obsoleto o contrario al alcance clean-room.

## Instalación y plataforma

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Instalar el entorno desde shell | Script único y lineal | Entradas pequeñas, bibliotecas y componentes | Mejorado |
| Exigir privilegios | Ejecución completa como root | Elevación para APT y archivos root-owned declarados; escritorio como usuario objetivo | Mejorado |
| Detectar usuario real | Dependencia directa de `SUDO_USER` | SUDO, usuario directo y override explícito validados con NSS | Mejorado |
| Detectar distribución | No existe detección robusta | `/etc/os-release`, Parrot 7.x, Debian 13 experimental y amd64 | Implementado |
| Actualizar índices APT | Sí | Sí, integrado en el launcher | Implementado |
| Modificar fuentes APT | Modifica `sources.list` | Nunca modifica repositorios | Mejorado |
| Comprobar paquetes existentes | Parcial | `dpkg-query` antes de instalar | Mejorado |
| Comprobar disponibilidad | No | `apt-cache` y fallo explícito | Mejorado |
| Usar paquetes Parrot/Debian | Mezcla de APT, builds y binarios incluidos | APT-first | Mejorado |
| Compilar ramas Git | BSPWM, SXHKD, Polybar y Picom | No se compilan si existe paquete compatible | Mejorado |
| Versionar dependencias upstream | No | Powerlevel10k por tag y Oh My Zsh por commit | Mejorado |
| Verificar descargas | No | Checksum oficial para Nerd Fonts | Mejorado |
| Instalación unificada | No | Un launcher instala el conjunto completo | Mejorado |
| Menú de instalación | No | Menú interactivo y flags automatizables | Implementado |
| Simulación | No | `--dry-run` | Implementado |
| Backups | No sistemáticos | Backup con manifiesto antes de reemplazar | Mejorado |
| Segunda ejecución | Puede duplicar/clonar/sobrescribir | Detección de paquetes, repositorios, archivos y bloques | Mejorado; pendiente Parrot |
| Logs | Mensajes en terminal | Niveles y logs por ejecución | Implementado |
| Desinstalación | No | Manifiesto, checksums y paquetes preexistentes protegidos | Implementado; pendiente Parrot |

## Sesión gráfica y ventanas

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| BSPWM sobre X11 | Sí | Paquete oficial con configuración propia | Pendiente Parrot |
| Convivir con el escritorio instalado | Implícito | No cambia display manager ni KDE/MATE | Mejorado; pendiente Parrot |
| Selector de sesión | Entrada aportada por BSPWM | Se usa la entrada del paquete Debian | Pendiente Parrot |
| Diez escritorios | Números romanos | Escritorios 1–10, repartidos 5/5 con dos monitores | Implementado |
| Mosaico y monocle | Sí | Sí, con valores y paleta propios | Implementado |
| Bordes y separación | Sí | Sí, mediante diseño Nocturne | Implementado |
| Reglas de aplicaciones | Varias reglas heredadas | Reglas mínimas para Gimp, Pavucontrol y Feh | Implementado |
| Foco direccional | Flechas | H/J/K/L | Implementado |
| Intercambio direccional | Flechas | Shift + H/J/K/L | Implementado |
| Estados tiled/floating/fullscreen | Sí | Sí | Implementado |
| Preselección | Sí | Mapa propio Super+Ctrl+Alt | Implementado |
| Redimensionado | Script auxiliar | Script nuevo con validación y tamaño configurable | Mejorado |
| Fondo | Colección incluida | Ruta del usuario mediante `AEM_WALLPAPER` | Mejorado por licencias |
| Integración VMware | Arranque incondicional | Detección previa del ejecutable y proceso | Mejorado |
| Simulación de nombre de WM | `wmname` forzado | Omitido hasta demostrar necesidad | Excluido |

## Aplicaciones y atajos

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Abrir terminal | Kitty | Kitty | Implementado |
| Lanzador | Rofi drun | Rofi con tema propio | Implementado; visual pendiente |
| Capturas | Flameshot | Flameshot | Implementado; pendiente X11 |
| Bloqueo | i3lock-fancy clonado | i3lock oficial con color propio | Mejorado; pendiente X11 |
| Menú de energía | Rofi | Rofi con confirmación para reiniciar/apagar | Mejorado; pendiente systemd |
| Lanzadores personales | Telegram, Discord, VirtualBox, Obsidian y otros | No se incorporan rutas personales | Excluido |
| Cambio de teclado externo | Ruta global específica | No se asume script ajeno | Excluido |

## Polybar

| Funcionalidad | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Escritorio actual | Sí | Módulo BSPWM | Implementado; render pendiente |
| CPU | Configuración genérica disponible | Módulo visible | Implementado |
| RAM | Configuración genérica disponible | Módulo visible | Implementado |
| IP local | Script de primera interfaz | Ruta predeterminada e interfaz descubierta | Mejorado |
| Estado de red | Nombre de interfaz fijo en parte de la configuración | Sin nombres de interfaz codificados | Mejorado |
| VPN | Solo `tun0`, mediante ifconfig | `tun*`, `tap*`, `wg*`, configurable e iproute2 | Mejorado |
| Target | Archivo de texto en configuración | JSON bajo XDG state, validado y atómico | Mejorado |
| Volumen | ALSA | PulseAudio/PipeWire mediante módulo compatible | Mejorado; pendiente Parrot |
| Batería | `BAT0`/`AC0` | Descubrimiento en sysfs; módulo vacío si no existe | Mejorado |
| Fecha y hora | Sí | Sí | Implementado |
| Bandeja | Configuración de barra heredada | Módulo tray de Polybar 3.7 | Actualizado |
| Apagado/reinicio | Menú directo | Menú con segunda confirmación | Mejorado |
| Varios monitores | Geometrías rígidas | Una barra por monitor detectado | Mejorado; pendiente Parrot |
| Apariencia segmentada | Varias barras flotantes | Barra unificada redondeada y adaptable | Equivalencia funcional; visual pendiente |

## Terminal y shell

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Kitty | Configuración completa copiada | Configuración nueva, pequeña y documentada | Implementado; visual pendiente |
| Zsh | Reemplaza `.zshrc` | Añade un bloque gestionado que carga módulos XDG | Mejorado |
| Configuración de root | Copia y enlaza archivos del usuario | Configuración root-owned aislada en `/etc` y `/usr/local`, con bloques reversibles | Mejorado |
| Powerlevel10k | Clon sin versión y configuración completa | Tag fijado y configuración propia mínima | Mejorado |
| Oh My Zsh | No es parte efectiva del instalador observado | Incluido desde un commit oficial fijado | Añadido |
| Autosuggestions/highlighting | APT | APT | Implementado |
| fzf | Instalación manual por usuario y root | Paquete APT e integración Debian | Mejorado |
| bat y lsd | Paquetes `.deb` incluidos | Paquetes APT | Mejorado |
| Neofetch | Paquete antiguo | Fastfetch | Actualizado |
| Aliases | Colección extensa | Colección pequeña y opt-in en shell interactiva | Implementado |

## Neovim

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Ejecutable | Binario almacenado en el repo | Paquete APT | Mejorado |
| Configuración | Instrucciones para clonar NvChad | Lua propio modular y mínimo | Implementado |
| Plugins | Distribución externa completa | Ninguno por defecto | Parcial deliberado |
| Arranque headless | No automatizado | Previsto en checklist de Parrot | Pendiente Parrot |

## Flujo pentest

| Comportamiento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Definir target | Función Zsh sin validación | `targetctl set` con IPv4/IPv6 y nombre seguro | Mejorado y probado |
| Mostrar target | Script que lee campos con herramientas shell | Salida texto, JSON y Polybar | Mejorado y probado |
| Limpiar target | Vacía un archivo | Eliminación controlada del estado | Mejorado y probado |
| Preparar directorios | Tres carpetas fijas | Cuatro carpetas idempotentes en destino validado | Mejorado |
| Extraer puertos Nmap | Pipeline específico | Parser propio, ordenado y con portapapeles opcional | Implementado |
| VPN de laboratorio | Ruta personal HTB | Perfil aportado por el usuario | Mejorado |
| TryHackMe/WireGuard | No | Detección genérica por patrones | Añadido |
| Lanzador de software modificado | Presente en shell | No se incluye | Excluido por seguridad/licencia |

## Apariencia y branding

| Elemento | Referencia | Aemdlc Environment | Estado |
|---|---|---|---|
| Nombre y autor | Branding ajeno | Aemdlc Environment / Aemdlcdev | Implementado |
| Paleta | Colores heredados | Nocturne y Daybreak | Implementado; visual pendiente |
| Tipografía | Muchas fuentes incluidas | Una familia oficial descargada y verificada | Mejorado |
| Fondos | Colección incluida | Ninguno incluido | Excluido por decisión aprobada |
| Logo | Asset ajeno | No se incluye logo todavía | Pendiente opcional |
| Capturas | Capturas heredadas | Placeholders hasta probar el entorno real | Pendiente Parrot |

## Resultado de la auditoría funcional

La implementación cubre el núcleo funcional solicitado y mejora instalación, portabilidad, estado target, red/VPN, seguridad y mantenimiento. La integración de root no carga archivos modificables por el usuario y comparte el target bajando privilegios. Se mantienen como diferencias intencionadas la ausencia de binarios, fondos y lanzadores personales, forks no necesarios y utilidades sin justificación actual.

No puede declararse todavía equivalencia visual final ni instalación validada: esas afirmaciones requieren ejecutar la checklist en Parrot OS 7.3 amd64 con X11. Los puntos pendientes están enumerados en `docs/testing-parrot-7.3.md`.

