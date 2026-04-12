# Dotfiles

Stow configuration for TMUX, Zsh, Neovim, and Ghostty.

**Prerequisite**: Install GNU Stow (e.g., `sudo apt install stow`).  
**Warning**: This will symlink `~/.config` as a directory. Back up existing configs if needed.

## Structure

```
dotfiles/
├── dot-tmux.conf          # tmux configuration
├── dot-zshrc              # zsh configuration  
└── dot-config/
    ├── nvim/              # Neovim configuration (LazyVim based)
    └── ghostty/           # Ghostty terminal emulator config
```

## Setup (single command)

```bash
# From the dotfiles directory:
stow --dotfiles -t ~ .
```

This creates:
- `~/.tmux.conf` → `dot-tmux.conf`
- `~/.zshrc` → `dot-zshrc`
- `~/.config` → `dot-config/` (contains nvim and ghostty)

## Removing symlinks

```bash
# From the dotfiles directory:
stow -D --dotfiles -t ~ .
```

## Additional setup

### Making Zsh default shell
After linking `.zshrc`, install Zsh if not already installed (`sudo apt install zsh`), then set it as default:

```bash
chsh -s $(which zsh)
```

Log out and back in for the change to take effect.

**Optional packages used by `.zshrc`** (Ubuntu/Debian):
```bash
sudo apt install zsh-autosuggestions zsh-syntax-highlighting eza zoxide
```

### TMUX default shell
The `dot-tmux.conf` is configured to use Zsh as the default shell (`set -g default-shell /usr/bin/zsh`). If Zsh is installed in a different location, update the path accordingly.

### TMUX plugins
The `dot-tmux.conf` includes [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm) with several plugins preconfigured.

After starting tmux, install plugins with:

```
<prefix> + I   # (Ctrl-a I)
```

Plugins include:
- [tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux) – theme
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) – seamless vim/tmux navigation
- [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) – session persistence
- [tmux-continuum](https://github.com/tmux-plugins/tmux-continuum) – automatic session saving

## Alternative: separate packages

If you prefer granular control or already have a `~/.config` directory with other configs:

1. **Reorganize**:

   ```bash
   mkdir -p tmux zsh config
   mv dot-tmux.conf tmux/.tmux.conf
   mv dot-zshrc zsh/.zshrc
   mv dot-config/* config/
   rmdir dot-config
   ```

2. **Link**:

   ```bash
   stow -t ~ tmux zsh                # creates ~/.tmux.conf and ~/.zshrc
   stow -t ~/.config config          # creates ~/.config/nvim and ~/.config/ghostty
   ```

3. **Remove**:

   ```bash
   stow -D -t ~ tmux zsh
   stow -D -t ~/.config config
   ```