# Aemdlc Environment

Entorno BSPWM modular para Parrot OS 7.3, construido para convivir con el escritorio instalado y aportar un flujo de trabajo ágil para terminal, desarrollo y laboratorios de seguridad.

El proyecto instala componentes desde los repositorios activos de Parrot/Debian siempre que sea posible. No cambia fuentes APT, no reemplaza el escritorio existente y no distribuye binarios, fuentes o fondos de terceros. Incluye un fondo original propio.

> Estado: candidato inicial con implementación y auditorías clean-room completadas. Debe validarse en una máquina o VM Parrot OS 7.3 antes de considerarse estable.

## Capturas

Las capturas se añadirán después de validar la instalación real:

- `[captura: escritorio Nocturne]`
- `[captura: tema Daybreak]`
- `[captura: flujo target y VPN]`

## Características

- BSPWM y SXHKD sobre X11 sin retirar KDE/MATE.
- Polybar adaptable a varios monitores.
- CPU, RAM, audio, batería condicional, red, VPN, target y reloj.
- Kitty, Rofi, Picom y Flameshot.
- Zsh modular con fzf, sugerencias, resaltado y Powerlevel10k.
- Neovim propio y deliberadamente pequeño.
- Temas originales `nocturne` y `daybreak`.
- Herramientas `targetctl`, `pentest-workspace` y `nmap-ports`.
- Launcher completo, simulación, backups, logs y manifiesto.
- Desinstalación conservadora.

## Requisitos

- Parrot OS 7.x, con prioridad de pruebas en 7.3.
- Arquitectura amd64/x86_64.
- APT y systemd.
- Servidor X11 y gestor de inicio de sesión.
- Conexión HTTPS para Powerlevel10k y Nerd Fonts.
- Usuario con acceso a `sudo`.

El launcher acepta Parrot OS 7.x sobre `amd64`; Debian puro, Ubuntu, Kali y otras distribuciones se rechazan para evitar aplicar cambios sobre una plataforma no validada.

## Instalación

Clona el repositorio, entra en su directorio y ejecuta un único launcher como usuario normal:

```bash
./install.sh
```

El launcher instala el entorno completo, incluyendo BSPWM, Polybar, Picom, Kitty, Rofi, Zsh, Oh My Zsh, Powerlevel10k, Neovim y las herramientas de pentest. Utiliza el tema `nocturne`, actualiza los índices APT y solicita privilegios solo cuando son necesarios.

Al terminar, cierra sesión y selecciona `bspwm` en el gestor de acceso.

La única comprobación opcional es una simulación completa:

```bash
./install.sh --dry-run
```

Opciones disponibles:

```text
--dry-run
--yes
--help
```

## Configuración

La especificación utilizada para mantener la apariencia se documenta en [docs/visual-parity.md](docs/visual-parity.md).

Los archivos instalados se distribuyen entre:

```text
~/.config/bspwm/
~/.config/sxhkd/
~/.config/polybar/
~/.config/picom/
~/.config/kitty/
~/.config/nvim/
~/.config/aemdlc-environment/
~/.local/share/aemdlc-environment/
~/.local/state/aemdlc-environment/
```

### Fondo

El tema Nocturne aplica el fondo original del proyecto. Puedes sustituirlo para una sesión definiendo:

```bash
export AEM_WALLPAPER="$HOME/Imágenes/mi-fondo.jpg"
```

Puedes guardar esa variable en un archivo de entorno de tu sesión.

### Temas

```bash
theme-switcher nocturne
theme-switcher daybreak
```

### Target

```bash
targetctl set 10.10.10.10 maquina-lab
targetctl show
targetctl clear
```

El estado se guarda como JSON con permisos de usuario en `~/.local/state/aemdlc-environment/target.json`.

### VPN

La barra reconoce de forma predeterminada interfaces `tun*`, `tap*` y `wg*`. Personaliza los prefijos con `AEM_VPN_PATTERNS`.

### Comandos incluidos

Los comandos se instalan en `~/.local/share/aemdlc-environment/bin/`. El instalador añade esa ruta al entorno del usuario.

| Comando | Acción |
|---|---|
| `doctor` | Comprueba programas, sesión, monitores, fuentes y DPI |
| `targetctl set <IP> <nombre>` | Define la máquina objetivo |
| `targetctl show` | Muestra el objetivo actual |
| `targetctl clear` | Elimina el objetivo actual |
| `theme-switcher nocturne` | Activa el tema oscuro |
| `theme-switcher daybreak` | Activa el tema claro |
| `pentest-workspace [directorio]` | Crea `scans`, `content`, `exploits` y `notes` |
| `nmap-ports <archivo-nmap>` | Extrae y copia los puertos TCP abiertos |
| `power-menu` | Abre el menú de bloqueo, suspensión y apagado |
| `launch-polybar` | Reinicia todas las barras administradas |

Comandos de mantenimiento desde el directorio del proyecto:

| Comando | Acción |
|---|---|
| `./install.sh` | Instala el entorno completo |
| `./update.sh --yes` | Actualiza una instalación existente |
| `./uninstall.sh` | Desinstala únicamente los archivos administrados |

### Shell de root

La instalación completa añade una integración separada y propiedad de `root`. Al ejecutar `sudo su`, Bash transfiere la sesión interactiva a Zsh con Powerlevel10k sin cambiar permanentemente el shell registrado en `/etc/passwd`.

Dentro de la shell de root funcionan `targetctl`, `settarget`, `showtarget`, `cleartarget`, `pentest-workspace`, `nmap-ports` y `doctor`. `targetctl` baja privilegios automáticamente al usuario del escritorio para compartir el mismo estado que Polybar.

Los comandos gráficos `power-menu`, `launch-polybar` y `theme-switcher` deben ejecutarse como usuario normal. Ejecutar aplicaciones X11 como root queda deliberadamente bloqueado por separación de privilegios.

La arquitectura, rutas administradas y límites de seguridad se describen en [docs/root-integration.md](docs/root-integration.md).

## Atajos de teclado

`Super` es la tecla Windows. La configuración instalada incluye:

| Atajo | Acción |
|---|---|
| `Super + Enter` | Abrir Kitty |
| `Super + Espacio` | Abrir Rofi |
| `Super + Shift + S` | Captura con Flameshot |
| `Super + Shift + X` | Bloquear |
| `Super + Shift + P` | Menú de energía |
| `Super + Q` | Cerrar la ventana enfocada |
| `Super + Shift + Q` | Forzar el cierre de la ventana enfocada |
| `Super + Shift + R` | Recargar BSPWM |
| `Super + Shift + M` | Alternar disposición monocle |
| `Super + T` | Poner la ventana en mosaico |
| `Super + Shift + T` | Poner la ventana en modo flotante |
| `Super + F` | Alternar pantalla completa |
| `Super + Ctrl + M` | Marcar o desmarcar una ventana |
| `Super + Ctrl + S` | Hacer una ventana adhesiva |
| `Super + Ctrl + P` | Hacer una ventana privada |
| `Super + H/J/K/L` | Enfocar oeste/sur/norte/este |
| `Super + Shift + H/J/K/L` | Intercambiar con la ventana al oeste/sur/norte/este |
| `Super + [ / ]` | Ir al escritorio anterior/siguiente |
| `Super + Tab` | Volver al último escritorio |
| `Super + 1…0` | Ir a los escritorios 1…10 |
| `Super + Shift + 1…0` | Enviar la ventana al escritorio y seguirla |
| `Super + Ctrl + Alt + H/J/K/L` | Preseleccionar oeste/sur/norte/este |
| `Super + Ctrl + Alt + 1…9` | Ajustar la proporción de preselección |
| `Super + Ctrl + Alt + Espacio` | Cancelar la preselección |
| `Super + Alt + H/J/K/L` | Redimensionar la ventana hacia cada dirección |
| `Super + Alt + Shift + H/J/K/L` | Mover la ventana en pasos de 24 px |
| `Super + Escape` | Recargar SXHKD |

## Estructura

- `lib/`: primitivas del instalador.
- `components/`: instalación de cada componente.
- `config/`: configuraciones originales desplegables.
- `scripts/`: utilidades de sesión y pentest.
- `metadata/`: identidad, componentes y versiones.
- `docs/`: diseño, configuración y pruebas.
- `tests/`: validaciones estáticas y unitarias.

## Actualización

```bash
./update.sh --dry-run --yes
./update.sh
```

El actualizador no ejecuta una actualización completa del sistema. Los paquetes APT siguen el ciclo normal de Parrot.

## Desinstalación

```bash
./uninstall.sh
```

Los paquetes instalados se conservan por defecto. Para ofrecer su retirada:

```bash
./uninstall.sh --purge-packages
```

Los backups no se borran automáticamente.

## Diagnóstico

Ejecuta:

```bash
~/.local/share/aemdlc-environment/bin/doctor
```

Problemas habituales:

- Si BSPWM no aparece, confirma que el paquete `bspwm` está instalado y reinicia el gestor de acceso.
- Si faltan iconos, ejecuta `fc-cache -f` y reinicia Polybar/Kitty.
- Si Polybar no ve audio, verifica que PulseAudio/PipeWire exponga el backend compatible.
- Si una barra no aparece en un monitor, revisa `polybar --list-monitors`.
- Consulta los logs en `~/.local/state/aemdlc-environment/logs/`.

## Seguridad

Consulta [SECURITY.md](SECURITY.md). No ejecutes instaladores modificados por terceros como root. El proyecto no solicita ni almacena credenciales.

## Créditos

Construido con proyectos libres mantenidos por sus respectivas comunidades. Inspirado conceptualmente en distintos entornos BSPWM para Parrot/Kali, incluido [ParrotEntorno](https://github.com/Balthael/ParrotEntorno). Aemdlc Environment conserva una implementación, estructura, documentación y recursos propios.

## Licencias

El código original de Aemdlc Environment se publica bajo MIT. Las herramientas instaladas mantienen sus propias licencias; consulta [THIRD_PARTY.md](THIRD_PARTY.md).

