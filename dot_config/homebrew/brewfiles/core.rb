# Core Brew packages

brew "exercism"
brew "uv"
brew "luarocks"
brew "sevenzip"
brew "pcre2"
brew "less"
brew "weechat"
brew "libmagic"

cask "ngrok" if OS.mac?
cask "docker-desktop" if OS.mac?
cask "font-jetbrains-mono-nerd-font" if OS.mac?
cask "ghostty" if OS.mac?
cask "google-chrome" if OS.mac?
