# Paridad visual

Esta revisión utiliza como referencia principal las capturas públicas del proyecto citado en los créditos. Las capturas pertenecen a una revisión anterior a parte de su configuración actual, por lo que, cuando ambos datos se contradicen, prevalece el resultado visible de las capturas.

## Contrato para 1920×1080

- Polybar: seis cápsulas a 15 px del borde superior y 40 px de altura.
- Posiciones horizontales: `1%`, `4%`, `14.3%`, `41%`, `79.7%` y `96.9%`.
- Superficie de Polybar: `#435060`; texto principal blanco.
- BSPWM: gap de 12 px, split `0.52` y sin borde visible.
- Kitty: Hack Nerd Font 13, padding de 20 px, opacidad `0.85`, fondo `#1a1b26` y texto `#a9b1d6`.
- Picom: GLX, radio 20, sombra con radio 15 y opacidad `0.5`, sin blur.
- Rofi launcher: `17% × 31%`, anclado en la zona inferior izquierda.
- Rofi power: `12% × 27%`, anclado en la zona superior derecha.

El contrato se comprueba estáticamente mediante `tests/visual-contract.sh`.

## Diferencias deliberadas o pendientes

- El wallpaper es un recurso propio: conserva una luminancia y contraste compatibles, pero no reproduce el asset de procedencia incierta.
- La salida target conserva el orden visible `nombre - IP`, aunque una revisión del script de referencia utilizaba el orden contrario.
- No se configura automáticamente el shell de `root`: hacerlo ampliaría el alcance de la instalación y modificaría una cuenta distinta del usuario objetivo.
- NvChad actual requiere Neovim 0.11. Debian 13 distribuye Neovim 0.10.4, por lo que no se instala automáticamente una versión incompatible ni se incorpora la copia binaria antigua del repositorio de referencia.
- La validación pixel-perfect de baseline, antialiasing y DPI requiere capturas obtenidas en una sesión Parrot OS 7.3 real.

## Verificación en Parrot

Después de aplicar una actualización, reinicia la sesión BSPWM y ejecuta:

```bash
~/.local/share/aemdlc-environment/bin/doctor
```

Comprueba escritorio vacío, Kitty, dos terminales tiled, Rofi, VPN conectada y desconectada, y target presente y vacío a 1920×1080. El diagnóstico informa de fuentes resueltas y del valor de `Xft.dpi`.
