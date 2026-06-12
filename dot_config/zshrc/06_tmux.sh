#
#    ▄▄▄▄▄ ▄▄   ▄▄ ▄▄  ▄▄ ▄▄  ▄▄
#      ██  ███▄███ ██  ██  ▀██▄▀
#      ██  ██ ▀ ██ ▀████▀ ▄█▀██▄
#
#    Auto-start tmux using DennieTeMolder/zsh-tmux

if is_standalone_terminal; then
	ZSH_TMUX_AUTOSTART=true
	ZSH_TMUX_AUTOCONNECT=true
	zinit light DennieTeMolder/zsh-tmux
fi
