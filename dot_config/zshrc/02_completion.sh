#                                                                 
#     ▄▄▄▄  ▄▄▄  ▄▄   ▄▄ ▄▄▄▄  ▄▄    ▄▄▄▄▄ ▄▄▄▄▄▄ ▄▄  ▄▄▄  ▄▄  ▄▄ 
#    ██▀▀▀ ██▀██ ██▀▄▀██ ██▄█▀ ██    ██▄▄    ██   ██ ██▀██ ███▄██ 
#    ▀████ ▀███▀ ██   ██ ██    ██▄▄▄ ██▄▄▄   ██   ██ ▀███▀ ██ ▀██ 
#                                                                 
#    This file is in charge of prompt and text completion.
#    All of the required completion scripts should be here.

zinit light zsh-users/zsh-syntax-highlighting
zinit light changyuheng/zsh-interactive-cd
zinit light "MichaelAquilina/zsh-you-should-use"
zinit light zsh-users/zsh-history-substring-search 

# Zoxide
zinit ice wait"2" as"command" from"gh-r" lucid \
  atclone"./zoxide init zsh > init.zsh" \
  atpull"%atclone" src"init.zsh" nocompile'!' \
  atload"unalias zi 2>/dev/null; alias cd='z'"
zinit light ajeetdsouza/zoxide

# Completion style
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'

# Carapace
zinit wait lucid from"gh-r" as"program" \
  mv"carapace* -> carapace" \
  atload'zicompinit; zicdreplay; export CARAPACE_BRIDGES="zsh,bash,fish,inshellisense"; eval "$(carapace _carapace zsh)"' \
  for carapace-sh/carapace-bin
