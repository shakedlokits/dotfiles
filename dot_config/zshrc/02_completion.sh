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
  atload"unalias zi 2>/dev/null; alias j='z'; alias jj='zi'; alias cd='z'"
zinit light ajeetdsouza/zoxide
