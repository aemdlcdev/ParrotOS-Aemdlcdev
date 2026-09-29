# Estrategia de paquetes

La instalación consulta primero `dpkg-query` y después `apt-cache`. Solo llama a APT si el paquete no está instalado y tiene candidato en los repositorios activos.

Paquetes centrales esperados en Parrot 7.3/Debian 13:

```text
bspwm sxhkd polybar picom kitty rofi zsh neovim fzf flameshot
feh i3lock fastfetch bat lsd ripgrep openvpn xclip pavucontrol
```

Powerlevel10k, Oh My Zsh y las familias JetBrainsMono, Iosevka y Hack Nerd Font se obtienen desde sus repositorios/releases oficiales con versión fijada. Cada archivo de fuente se verifica con el checksum publicado por GitHub.

El instalador nunca añade repositorios ni modifica listas APT.

