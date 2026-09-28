# Fase 2 — Arquitectura propuesta

Estado: propuesta lista para revisión. Esta fase no contiene todavía configuraciones finales ni lógica de instalación.

## 1. Objetivos de diseño

La arquitectura se orientará a estos principios:

1. **APT primero.** Los paquetes de Parrot/Debian son la fuente predeterminada. Las instalaciones desde upstream serán excepciones explícitas, versionadas y verificadas.
2. **Privilegios mínimos.** La mayor parte del proceso se ejecutará como el usuario objetivo. Solo APT, archivos de sistema y cambios de shell requerirán privilegios elevados.
3. **Estado conocido.** Cada archivo y paquete administrado quedará registrado para poder actualizar y desinstalar sin afectar elementos preexistentes.
4. **Configuración no destructiva.** Antes de reemplazar un archivo se creará una copia de seguridad. Cuando sea posible se usarán includes o bloques gestionados.
5. **Idempotencia verificable.** Cada módulo declarará detección, instalación, configuración, comprobación y desinstalación.
6. **Separación entre código, configuración y estado.** El repositorio contendrá plantillas; el estado de ejecución se guardará bajo rutas XDG del usuario.
7. **Sin artefactos de terceros incluidos.** No se almacenarán binarios, paquetes Debian, fuentes ni imágenes ajenas.
8. **Compatibilidad conservadora.** Parrot OS 7.x será la plataforma admitida; Debian 13 será experimental. El resto requerirá una opción consciente de anulación.

## 2. Identidad centralizada

El nombre público todavía puede cambiar. Toda la implementación leerá una única definición:

```text
PROJECT_NAME = nombre visible
PROJECT_ID   = identificador minúsculo apto para rutas
AUTHOR       = autor o seudónimo
REPOSITORY   = URL pública, cuando exista
```

El identificador se utilizará en rutas como:

```text
~/.config/<PROJECT_ID>/
~/.local/state/<PROJECT_ID>/
~/.local/share/<PROJECT_ID>/
~/.cache/<PROJECT_ID>/
```

Esto evita introducir nombres de usuario, rutas personales o branding duplicado.

## 3. Árbol del proyecto

```text
project-root/
├── install.sh
├── uninstall.sh
├── update.sh
├── LICENSE
├── README.md
├── CHANGELOG.md
├── THIRD_PARTY.md
├── SECURITY.md
├── .editorconfig
├── .gitignore
│
├── metadata/
│   ├── project.conf
│   ├── components.conf
│   └── versions.conf
│
├── installer/
│   ├── bootstrap.sh
│   ├── cli.sh
│   └── uninstall.sh
│
├── lib/
│   ├── common.sh
│   ├── logging.sh
│   ├── platform.sh
│   ├── identity.sh
│   ├── privilege.sh
│   ├── apt.sh
│   ├── upstream.sh
│   ├── filesystem.sh
│   ├── backup.sh
│   ├── manifest.sh
│   ├── xdg.sh
│   └── validation.sh
│
├── components/
│   ├── x11.sh
│   ├── bspwm.sh
│   ├── sxhkd.sh
│   ├── polybar.sh
│   ├── picom.sh
│   ├── kitty.sh
│   ├── rofi.sh
│   ├── shell.sh
│   ├── neovim.sh
│   ├── fonts.sh
│   ├── desktop-tools.sh
│   └── pentest-workflow.sh
│
├── config/
│   ├── bspwm/
│   │   └── bspwmrc
│   ├── sxhkd/
│   │   └── sxhkdrc
│   ├── polybar/
│   │   ├── config.ini
│   │   ├── bars.ini
│   │   ├── modules.ini
│   │   └── themes/
│   ├── picom/
│   │   └── picom.conf
│   ├── kitty/
│   │   ├── kitty.conf
│   │   └── themes/
│   ├── rofi/
│   │   ├── launcher.rasi
│   │   ├── power-menu.rasi
│   │   └── themes/
│   ├── zsh/
│   │   ├── zshrc
│   │   ├── aliases.zsh
│   │   ├── completion.zsh
│   │   ├── keybindings.zsh
│   │   └── pentest.zsh
│   └── nvim/
│       ├── init.lua
│       └── lua/
│
├── scripts/
│   ├── session-start.sh
│   ├── launch-polybar.sh
│   ├── network-status.sh
│   ├── vpn-status.sh
│   ├── targetctl
│   ├── target-status.sh
│   ├── power-menu.sh
│   ├── theme-switcher.sh
│   ├── resize-window.sh
│   ├── workspace-init.sh
│   └── doctor.sh
│
├── assets/
│   ├── README.md
│   └── wallpapers/
│
├── docs/
│   ├── architecture.md
│   ├── configuration.md
│   ├── keyboard.md
│   ├── packages.md
│   ├── themes.md
│   ├── troubleshooting.md
│   ├── uninstall.md
│   ├── clean-room.md
│   └── testing-parrot-7.3.md
│
└── tests/
    ├── unit/
    ├── integration/
    ├── fixtures/
    ├── lint.sh
    └── smoke.sh
```

### Diferencias respecto a una estructura simple por programa

- `components/` contiene los ciclos de instalación de alto nivel.
- `lib/` contiene primitivas reutilizables que no conocen BSPWM, Polybar u otros programas.
- `config/` solo contiene archivos que terminarán en el perfil del usuario.
- `scripts/` contiene herramientas de ejecución diaria, no lógica del instalador.
- `metadata/versions.conf` permite fijar versiones upstream sin editar módulos.
- `manifest.sh` registra exactamente qué creó el proyecto.

## 4. Capas de responsabilidad

### 4.1 Entradas públicas

`install.sh`, `update.sh` y `uninstall.sh` serán envoltorios pequeños. Su trabajo será:

- activar modo estricto;
- localizar la raíz del proyecto;
- cargar metadata y bibliotecas;
- delegar al comando interno correspondiente;
- mostrar un resumen final.

No contendrán listas extensas de paquetes ni configuraciones embebidas.

### 4.2 Biblioteca base

| Biblioteca | Responsabilidad |
|---|---|
| `common.sh` | Inicialización compartida y utilidades pequeñas. |
| `logging.sh` | Niveles de log, colores solo cuando hay TTY y archivo de sesión. |
| `platform.sh` | Lectura segura de `os-release`, arquitectura y compatibilidad. |
| `identity.sh` | Resolución del usuario real, UID, grupo y home mediante NSS. |
| `privilege.sh` | Ejecución controlada como root o como usuario objetivo. |
| `apt.sh` | Disponibilidad, estado instalado, actualización de índices e instalación. |
| `upstream.sh` | Clones fijados, releases, checksums y actualizaciones controladas. |
| `filesystem.sh` | Directorios, permisos, copias y enlaces gestionados. |
| `backup.sh` | Backups con fecha, metadatos y restauración. |
| `manifest.sh` | Inventario de archivos, enlaces y paquetes tocados. |
| `xdg.sh` | Cálculo consistente de rutas XDG. |
| `validation.sh` | Validación de IP, nombres, opciones, versiones y rutas. |

Las funciones públicas llevarán un prefijo propio derivado de `PROJECT_ID` para reducir colisiones al cargar módulos.

### 4.3 Componentes

Cada archivo de `components/` expondrá el mismo contrato conceptual:

```text
component_detect
component_plan
component_install
component_configure
component_verify
component_uninstall
```

Los nombres reales incluirán el identificador del componente. Ningún módulo ejecutará trabajo simplemente por ser importado.

## 5. Flujo del instalador

```text
Inicio
  → Validar Bash, arquitectura y sistema
  → Resolver usuario objetivo
  → Adquirir bloqueo de instalación
  → Crear log y directorios de estado
  → Presentar menú o procesar flags
  → Construir plan sin cambios
  → Mostrar resumen de paquetes/archivos
  → Confirmar
  → Actualizar índices APT si corresponde
  → Instalar componentes en orden
  → Desplegar configuraciones con backup
  → Verificar ejecutables y sintaxis
  → Guardar manifiesto
  → Mostrar próximos pasos sin cerrar sesión
```

Orden de dependencias propuesto:

1. Base, X11 y herramientas de sistema.
2. BSPWM y SXHKD.
3. Polybar, Picom, Kitty, Rofi y utilidades de escritorio.
4. Fuentes.
5. Zsh, complementos, fzf y Powerlevel10k.
6. Neovim.
7. Scripts de red, VPN y target.
8. Temas y autoinicio.
9. Verificación integral.

## 6. Modo de instalación

La propuesta inicial de perfiles fue sustituida por un launcher único para reducir decisiones y evitar instalaciones parciales inconsistentes. `./install.sh` instala el conjunto completo y usa valores seguros predefinidos.

La interfaz pública queda limitada a:

```text
--dry-run
--yes
--help
```

## 7. Estrategia de paquetes

Cada dependencia tendrá una declaración con:

- paquete preferido;
- componente que lo necesita;
- obligatorio u opcional;
- comando que proporciona;
- alternativa aceptada;
- método de instalación (`apt` o `upstream`);
- versión fijada si procede de upstream;
- licencia y URL para `THIRD_PARTY.md`.

Prioridad:

1. Paquete disponible en los repositorios activos de Parrot.
2. Paquete de Debian 13 que ya forme parte de la base compatible de Parrot.
3. Release o tag oficial de upstream, solo cuando exista una necesidad documentada.

El instalador no escribirá en `/etc/apt/sources.list` ni en `sources.list.d`.

## 8. Configuración y backups

### Archivos completos administrados

Las configuraciones dedicadas del proyecto, como `~/.config/bspwm/bspwmrc`, se instalarán de esta forma:

1. comparar contenido;
2. si es idéntico, no hacer nada;
3. si existe y no está administrado, guardar backup;
4. instalar mediante archivo temporal y renombrado atómico;
5. ajustar propietario y permisos;
6. registrar el resultado en el manifiesto.

### Archivos compartidos

Para `.zshrc` se evitará sustituir el archivo completo. Se preferirá un bloque mínimo que cargue:

```text
~/.config/<PROJECT_ID>/zsh/init.zsh
```

El bloque tendrá marcadores propios para poder actualizarlo y retirarlo sin tocar el resto del archivo.

### Copias de seguridad

```text
~/.local/state/<PROJECT_ID>/backups/<timestamp>/
├── manifest.tsv
└── home/...
```

El manifiesto conservará ruta original, tipo, propietario, modo y checksum.

## 9. Estado y manifiesto

```text
~/.local/state/<PROJECT_ID>/
├── install.lock
├── install-state.tsv
├── managed-files.tsv
├── preexisting-packages.txt
├── installed-packages.txt
├── target.json
├── backups/
└── logs/
```

- `preexisting-packages.txt` impedirá que la desinstalación quite programas que ya tenía el usuario.
- `installed-packages.txt` solo registrará paquetes añadidos por una ejecución exitosa.
- El estado target no contendrá comandos ni se evaluará como shell.
- Los archivos sensibles usarán permisos restrictivos.

## 10. Arquitectura de sesión X11

`bspwmrc` delegará en scripts pequeños:

```text
bspwmrc
  → workspace-init.sh
  → sxhkd, si no está activo
  → picom, si está habilitado
  → launch-polybar.sh
  → fondo configurado
  → flameshot, si está habilitado
  → integraciones de VM detectadas
```

Cada proceso se iniciará con detección previa para evitar duplicados. Los fallos opcionales se registrarán sin impedir que BSPWM arranque.

No se reemplazará la sesión KDE/MATE ni se cambiará el display manager.

## 11. Polybar modular

La configuración se dividirá en:

- `config.ini`: punto de entrada e includes;
- `bars.ini`: geometría adaptable;
- `modules.ini`: módulos internos y scripts;
- `themes/<theme>.ini`: colores y tipografía.

Distribución funcional propuesta:

| Zona | Contenido |
|---|---|
| Izquierda | lanzador, red local, VPN |
| Centro | escritorios BSPWM |
| Derecha | target, CPU, RAM, volumen, batería condicional, fecha y energía |

En pantallas estrechas se ocultarán primero módulos secundarios. Los monitores se descubrirán con XRandR y Polybar; el usuario podrá definir overrides.

## 12. Flujo target y VPN

### `targetctl`

Interfaz prevista:

```text
targetctl set <IP> <nombre>
targetctl show [--format text|json|polybar]
targetctl clear
```

Propiedades:

- IPv4 e IPv6 validadas;
- nombre limitado en longitud y caracteres de control;
- estado JSON sin evaluación por shell;
- escritura temporal y renombrado atómico;
- bloqueo para accesos concurrentes;
- salida de Polybar siempre válida, incluso sin target.

Se añadirán wrappers opcionales `settarget`, `showtarget` y `cleartarget` para la shell.

### VPN

`vpn-status.sh` aceptará una lista configurable de patrones de interfaz. No asumirá que HTB siempre usa `tun0` ni que TryHackMe usa una interfaz fija.

## 13. Temas

Un tema declarará como mínimo:

- fondo, superficie y texto;
- colores normal, activo, alerta y éxito;
- borde BSPWM;
- opacidad de terminal;
- familia tipográfica;
- fondo de escritorio opcional.

`theme-switcher.sh` validará el nombre y cambiará únicamente enlaces o archivos generados pertenecientes al proyecto. Después recargará de forma selectiva Polybar, SXHKD, Picom y Kitty cuando cada aplicación lo permita.

Los temas iniciales serán originales. Los nombres tentativos son `nocturne` y `daybreak`, sujetos a la marca final.

## 14. Neovim

La configuración inicial será deliberadamente pequeña:

- opciones base;
- atajos propios;
- gestor de plugins documentado;
- exploración de archivos, búsqueda y LSP como módulos opcionales;
- lockfile de plugins;
- comprobación con modo headless.

No se distribuirá un binario ni una copia de NvChad. Si se ofrece un perfil inspirado en una distribución de Neovim, se instalará desde su fuente y se documentará como componente externo opcional.

## 15. Actualización

`update.sh` tendrá dos ámbitos separados:

1. actualizar configuraciones y scripts del proyecto;
2. actualizar componentes obtenidos desde upstream respetando versiones fijadas.

No ejecutará una actualización completa del sistema por defecto. Los paquetes APT seguirán el ciclo normal de Parrot.

Una actualización mostrará primero los archivos modificados localmente y no los sobrescribirá sin backup.

## 16. Desinstalación

El desinstalador leerá el manifiesto y aplicará estas reglas:

- borrar solo archivos cuyo checksum siga coincidiendo con la versión instalada;
- conservar y señalar archivos modificados por el usuario;
- retirar únicamente bloques gestionados de archivos compartidos;
- ofrecer restaurar el backup anterior;
- desinstalar solo paquetes añadidos por el proyecto y únicamente con confirmación;
- no eliminar directorios XDG que contengan archivos ajenos;
- no tocar repositorios, metapaquetes, KDE/MATE ni herramientas propias de Parrot.

## 17. Pruebas

### Estáticas

- `bash -n` para todos los scripts;
- ShellCheck;
- validación de INI/Rasi/Lua cuando exista herramienta adecuada;
- búsqueda de rutas personales, tokens y binarios;
- comprobación de permisos ejecutables.

### Unitarias

- detección de `os-release` mediante fixtures;
- resolución de usuario con casos sudo y root directo;
- validación de IP y target;
- selección de interfaces;
- backups y manifiesto;
- cálculo de plan de paquetes.

### Integración

- ejecución `--dry-run` sin cambios;
- primera instalación;
- segunda instalación sin diferencias inesperadas;
- actualización con archivo local modificado;
- desinstalación con paquete preexistente;
- sesión BSPWM en X11.

### Plataforma de aceptación

La prueba final será Parrot OS 7.3 amd64, preferiblemente primero en una VM con snapshot y después en hardware representativo.

## 18. Seguridad

- URLs HTTPS y allowlist de orígenes oficiales.
- Sin `curl | bash`.
- Descargas a directorio temporal privado.
- Checksums de releases cuando estén publicados.
- Tags o versiones fijadas para clones.
- Sin evaluación de contenido descargado como shell.
- Sin secretos en logs.
- Rutas tratadas siempre como datos y entrecomilladas.
- Bloqueo contra ejecuciones simultáneas.
- Confirmación para cambiar shell, apagar, reiniciar o quitar paquetes.
- Rechazo de symlinks inesperados al desplegar configuraciones privilegiadas.

## 19. Documentación de licencias

- El código original del proyecto se publicará bajo MIT.
- `THIRD_PARTY.md` recogerá nombre, URL, licencia, método de obtención y uso.
- Los componentes instalados seguirán perteneciendo a sus autores.
- Los assets propios incluirán procedencia y licencia.
- No se copiarán configuraciones upstream salvo archivos de ejemplo cuya licencia lo permita y cuya inclusión aporte valor; en ese caso se conservarán sus avisos.

## 20. Puertas para comenzar la Fase 3

Antes de implementar deben quedar resueltos estos puntos:

1. nombre público, `PROJECT_ID`, autor y repositorio final;
2. paleta inicial y nombres de temas;
3. nombres de los diez escritorios;
4. mapa de atajos preferido o aceptación de una propuesta nueva;
5. si Oh My Zsh será predeterminado u opcional;
6. si la configuración de root queda completamente fuera, como se recomienda;
7. perfil de Neovim: mínimo propio o configuración más completa propia;
8. licencia/procedencia del fondo inicial, o ausencia de fondo incluido.

Hasta aprobar estas decisiones no se generarán las configuraciones finales, para evitar consolidar branding o comportamiento no deseado.
