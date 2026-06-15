# Core Brew packages

brew "exercism"
brew "luarocks"
brew "sevenzip"
brew "pcre2"
brew "less"
brew "weechat"
brew "libmagic"
brew "figlet"

cask "ngrok" if OS.mac?
cask "docker-desktop" if OS.mac?
cask "font-jetbrains-mono-nerd-font" if OS.mac?
cask "ghostty" if OS.mac?
cask "google-chrome" if OS.mac?
cask "handy" if OS.mac?
cask "raycast" if OS.mac?
