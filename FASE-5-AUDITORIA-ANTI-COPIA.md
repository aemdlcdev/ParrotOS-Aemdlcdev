# Fase 5 — Auditoría anti-copia

Fecha: 2026-09-28

## Alcance

Se comparó el repositorio nuevo con la instantánea `44dfcbac02aef7f4a0e425c98705b01c678b4789` del proyecto usado como referencia funcional.

La auditoría cubrió:

- código shell, Zsh, Lua y Python;
- configuraciones BSPWM, SXHKD, Polybar, Picom, Kitty y Rofi;
- README y documentación;
- nombres, comentarios y mensajes;
- rutas personales y branding;
- imágenes, fuentes, paquetes y binarios;
- orígenes externos y licencias;
- historial y remotos Git.

## Método y resultados

### 1. Comparación de bloques de código/configuración

Se normalizaron líneas no vacías y no comentadas de 27 archivos de texto relevantes de la referencia y 77 archivos de código/configuración del proyecto nuevo. Se buscaron secuencias exactas contiguas de tres líneas.

Resultado inicial: cuatro coincidencias en `sxhkdrc`, formadas por atajos y comandos estándar presentes en el ejemplo habitual de BSPWM/SXHKD.

Remediación: se cambió el mapa de preselección y el atajo de monocle para eliminar incluso esa coincidencia con la plantilla usada por la referencia.

Resultado final:

```text
Bloques exactos de tres líneas: 0
```

Comandos unitarios inevitables como `apt-get update`, `bspc node`, `systemctl reboot` o cabeceras shebang no se consideran expresión creativa ni evidencia de copia.

### 2. Comparación de documentación

Se tokenizó el README de la referencia y se buscaron secuencias exactas de ocho palabras en la documentación nueva, excluyendo los inventarios de análisis.

```text
Secuencias exactas de ocho palabras: 0
```

El README nuevo tiene estructura, redacción, instrucciones, mensajes y enfoque propios.

### 3. Código personalizado

Se revisaron especialmente las funciones con equivalentes conceptuales en la referencia:

- IP local;
- estado VPN;
- target;
- redimensionado BSPWM;
- lanzamiento de Polybar;
- preparación pentest;
- extracción de puertos;
- menú de energía.

Todas presentan estructura, validación, nombres, estado y manejo de errores nuevos. `targetctl` se implementó en Python con JSON y escrituras atómicas, una arquitectura distinta al archivo de texto y funciones shell observadas.

### 4. Branding y rutas personales

El barrido buscó nombres del autor/proyecto de referencia, rutas de usuario, carpetas localizadas, lanzadores personales y nombres asociados a implementaciones descartadas.

Resultado:

- ninguna ruta `/home/<autor>`;
- ningún nombre de usuario hardcodeado;
- ningún mensaje o banner del instalador original;
- ninguna función trasladada con su nombre/estructura;
- una única mención conceptual autorizada a `ParrotEntorno` en créditos;
- URL de referencia conservada únicamente en el inventario de Fase 1.

### 5. Assets y artefactos

Inventario final del repositorio:

```text
Archivos del proyecto: 98 (incluidos estos dos informes)
Binarios, .deb, fuentes o imágenes incluidos: 0
Archivos mayores de 2 MiB: 0
```

No se incorporaron fondos, capturas, logos, fuentes, ejecutables, runtimes de Neovim ni paquetes Debian de la referencia.

### 6. Git

El repositorio destino fue reinicializado antes de la implementación.

```text
Commits heredados: 0
Remotos heredados: 0
```

No existe relación de historial, fork, subtree, submodule ni remote con la referencia.

### 7. Dependencias y licencias

- Los componentes del sistema proceden de APT.
- Powerlevel10k se fija por tag oficial.
- Oh My Zsh opcional se fija por commit oficial.
- Nerd Fonts se descarga desde un release oficial y se verifica contra su checksum.
- `THIRD_PARTY.md` diferencia autores, proyectos, licencias y forma de uso.
- La licencia MIT cubre solo el código original de Aemdlc Environment.

### 8. Controles de seguridad relacionados

El barrido confirmó:

- ausencia de credenciales, tokens y claves privadas;
- ausencia de `curl | bash`;
- ausencia de modificaciones de `sources.list`;
- ausencia de repositorios Debian/Ubuntu/Kali añadidos;
- ausencia de loaders, keygens o binarios desconocidos;
- URLs externas limitadas a upstreams declarados.

## Limitaciones

Una auditoría estática no puede demostrar matemáticamente la ausencia absoluta de influencia conceptual. Sí puede demostrar que el repositorio entregado no contiene historial, archivos, assets, pasajes documentales ni bloques de implementación de la referencia según las comparaciones descritas.

Las configuraciones usan necesariamente nombres y comandos definidos por las interfaces públicas de BSPWM, SXHKD, Polybar, Picom, Kitty y Rofi. Esas coincidencias técnicas pertenecen a la sintaxis de cada herramienta y se atribuyen a sus upstreams.

## Conclusión

La auditoría anti-copia estática queda superada. Aemdlc Environment presenta una arquitectura, implementación, documentación, branding y modelo de estado propios. No se encontraron restos que requieran una nueva corrección después de la remediación de los cuatro bloques estándar de SXHKD.

