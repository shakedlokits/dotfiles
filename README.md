```
                                                       
   ████▄  ▄████▄ ██████ ██████ ██ ██     ██████ ▄█████ 
   ██  ██ ██  ██   ██   ██▄▄   ██ ██     ██▄▄   ▀▀▀▄▄▄ 
   ████▀  ▀████▀   ██   ██     ██ ██████ ██▄▄▄▄ █████▀ 
                                                       
   "Nothing like a new car... Oh shit, there goes the coffee."
```
After a decade of accumulating shell configurations into a single, increasingly sluggish `.zshrc`, this is a complete reimagining of my terminal setup. Gone are the days of monolithic configuration files and manual tool installations—welcome to a modular, cross-platform, and experiment-friendly command-line environment powered by modern dotfile management tools.

## Prerequisites

Before installing, ensure you have the following:

- **git** - Version control (likely already installed)
- **zsh** - Set as your default shell (`chsh -s $(which zsh)`)
- **curl** - For installation script
- **A Nerd Font** - Required for proper prompt rendering (JetBrains Mono Nerd Font recommended)
- **Homebrew** (macOS/Linux) - Optional but recommended for platform-specific tools

## Installation

Install these dotfiles with a single command using Chezmoi:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply shakedlokits
```

After installation, restart your shell or source your configuration:

```bash
zsh
```

That's it! Chezmoi will automatically:
- Clone the dotfiles repository
- Apply all configuration files
- Install Mise and configure development runtimes
- Install Homebrew packages (on macOS)
- Set up zinit and zsh plugins
- Configure Powerlevel10k prompt

## Architecture

This setup follows a modular architecture designed for cross-platform compatibility:

### Configuration Management
- **Chezmoi** - Dotfile management with template support and bootstrap hooks
- **Mise** - Runtime version management and cross-platform tool installation
- **Homebrew** - macOS-specific applications and packages
- **zinit** - Fast, flexible zsh plugin manager
- **Powerlevel10k** - Beautiful and blazingly fast prompt theme

### Directory Structure
```
~/.config/
├── mise/
│   └── conf.d/
│       ├── core.toml      # Cross-platform tools and runtimes
│       └── work.toml      # Work-specific tools
├── homebrew/
│   ├── Brewfile           # Main Brewfile that loads all sub-files
│   └── brewfiles/
│       ├── core.rb        # macOS-specific apps
│       └── work.rb        # Work-related macOS tools
└── zshrc/
    ├── 01_general.sh      # History, locale, editor settings
    ├── 02_completion.sh   # Zinit plugins and completions
    ├── 03_aliases.sh      # Command aliases
    └── 04_functions.sh    # Helper functions and utilities
```

## Useful Commands

```bash
# View all managed files
chezmoi managed -p all

# Update dotfiles from repository
chezmoi update

# Apply configuration changes
chezmoi apply

# Edit a config file (syncs back to repo)
chezmoi edit ~/.zshrc

# Check what would change
chezmoi diff

# Install/update Mise tools
mise install

# List installed runtimes and tools
mise list

# Install/update Homebrew packages (macOS)
brew bundle install --file ~/.config/homebrew/Brewfile
```

## Inspiration & Credits

Built with modern dotfile management tools:
- [Chezmoi](https://www.chezmoi.io/) - Dotfile manager
- [Mise](https://mise.jdx.dev/) - Development environment manager
- [zinit](https://github.com/zdharma-continuum/zinit) - Zsh plugin manager
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme

## License

MIT - Feel free to fork and adapt for your own use.
