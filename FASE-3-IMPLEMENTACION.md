# Fase 3 — Implementación

Estado: implementación inicial completa; pendiente de validación sobre Parrot OS 7.3 real.

## Implementado

- Repositorio independiente con identidad Aemdlc Environment.
- Instalador modular, interactivo y no interactivo.
- Perfiles completo, escritorio, shell, herramientas, pentest y mínimo.
- Detección de Parrot 7.x, Debian 13 experimental y amd64.
- Resolución de usuario real y separación de privilegios.
- APT-first con comprobación de paquetes instalados y disponibles.
- Backups, logs, manifiesto con checksum y bloqueo concurrente.
- BSPWM, SXHKD, Polybar, Picom, Kitty, Rofi, Zsh y Neovim.
- Powerlevel10k fijado y Oh My Zsh opcional fijado a commit.
- Descarga verificada de JetBrainsMono Nerd Font.
- Temas originales Nocturne y Daybreak.
- Red, VPN genérica, batería condicional y target en Polybar.
- `targetctl`, espacio pentest y extractor de puertos Nmap.
- Desinstalación conservadora.
- README, licencia MIT, terceros, seguridad y guías.
- Pruebas de sintaxis, smoke, plataforma y target.

## Validado en el host de desarrollo

- Sintaxis Bash de todos los scripts.
- Compilación sintáctica de `targetctl` con Python.
- Ciclo set/show/json/clear de `targetctl`.
- Ausencia de binarios y archivos superiores a 2 MiB.
- Ausencia de marcadores personales o implementaciones del repositorio de referencia.

## Pendiente de la plataforma objetivo

- Resolución real de candidatos APT de Parrot 7.3.
- Sesión BSPWM desde el display manager.
- Render de Polybar/Rofi/Kitty y glifos.
- Compatibilidad gráfica de Picom.
- Audio PipeWire/PulseAudio.
- Hardware de batería, varios monitores y VPN reales.
- Primera instalación, segunda ejecución y desinstalación en VM.

Estas pruebas no pueden sustituirse de forma honesta desde Windows. La checklist detallada se encuentra en `docs/testing-parrot-7.3.md`.
