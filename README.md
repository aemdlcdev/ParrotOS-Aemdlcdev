# Aemdlc Environment

Entorno BSPWM modular para Parrot OS 7.3, construido para convivir con el escritorio instalado y aportar un flujo de trabajo ágil para terminal, desarrollo y laboratorios de seguridad.

El proyecto instala componentes desde los repositorios activos de Parrot/Debian siempre que sea posible. No cambia fuentes APT, no reemplaza el escritorio existente y no distribuye binarios, fuentes o fondos de terceros.

> Estado: versión inicial de la Fase 3. Debe validarse en una máquina o VM Parrot OS 7.3 antes de considerarse estable.

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
- Instalación selectiva, simulación, backups, logs y manifiesto.
- Desinstalación conservadora.

## Requisitos

- Parrot OS 7.x, con prioridad de pruebas en 7.3.
- Arquitectura amd64/x86_64.
- APT y systemd.
- Servidor X11 y gestor de inicio de sesión.
- Conexión HTTPS para Powerlevel10k y Nerd Fonts.
- Usuario con acceso a `sudo`.

Debian 13 puede habilitarse como plataforma experimental. Ubuntu, Kali y otras distribuciones no están soportadas automáticamente.

## Instalación rápida

Revisa primero el plan:

```bash
chmod +x install.sh uninstall.sh update.sh
./install.sh --profile full --dry-run --yes
```

Después aplica la instalación:

```bash
./install.sh --profile full
```

El instalador solicitará privilegios solo cuando los necesite. No lo ejecutes desde una copia que no hayas revisado.

Al terminar, cierra sesión y selecciona `bspwm` en el gestor de acceso.

## Instalación selectiva

Perfiles disponibles:

```bash
./install.sh --profile desktop
./install.sh --profile shell
./install.sh --profile tools
./install.sh --profile pentest
./install.sh --profile minimal
```

También puedes indicar componentes:

```bash
./install.sh --components bspwm,sxhkd,kitty,rofi
```

Oh My Zsh es deliberadamente opcional y se instala desde un commit oficial fijado:

```bash
./install.sh --components shell,oh-my-zsh
```

Opciones destacadas:

```text
--theme nocturne|daybreak
--dry-run
--yes
--skip-apt-update
--allow-debian-13
--force-unsupported
```

## Configuración

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

No se incluye un fondo. Define uno antes de iniciar BSPWM:

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

## Atajos principales

| Atajo | Acción |
|---|---|
| `Super + Enter` | Abrir Kitty |
| `Super + Espacio` | Abrir Rofi |
| `Super + Q` | Cerrar ventana |
| `Super + 1…0` | Cambiar de escritorio |
| `Super + Shift + 1…0` | Enviar ventana y seguirla |
| `Super + H/J/K/L` | Cambiar el foco |
| `Super + Shift + H/J/K/L` | Intercambiar ventanas |
| `Super + Alt + H/J/K/L` | Redimensionar |
| `Super + Ctrl + Alt + H/J/K/L` | Preseleccionar dirección |
| `Super + Shift + S` | Captura con Flameshot |
| `Super + Shift + X` | Bloquear |
| `Super + Shift + P` | Menú de energía |

## Estructura

- `lib/`: primitivas del instalador.
- `components/`: instalación de cada componente.
- `config/`: configuraciones originales desplegables.
- `scripts/`: utilidades de sesión y pentest.
- `metadata/`: identidad, perfiles y versiones.
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

Construido con proyectos libres mantenidos por sus respectivas comunidades. Inspirado conceptualmente en distintos entornos BSPWM para Parrot/Kali, entre ellos ParrotEntorno, sin reutilizar su implementación ni sus recursos.

## Licencias

El código original de Aemdlc Environment se publica bajo MIT. Las herramientas instaladas mantienen sus propias licencias; consulta [THIRD_PARTY.md](THIRD_PARTY.md).

