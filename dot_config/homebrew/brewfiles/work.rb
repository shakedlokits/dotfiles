# Work Brew packages

brew "mongodb/brew/mongodb-community" if OS.mac?
brew "redpanda-data/tap/redpanda"
brew "nuclei"
brew "promptfoo"
brew "protobuf"

cask "lens" if OS.mac?
cask "openlens" if OS.mac?

