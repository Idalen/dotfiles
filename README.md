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

## Neovim Dependencies

The Neovim configuration is built on [Lazy.nvim](https://github.com/folke/lazy.nvim) plugin manager and uses the following GitHub repositories:

### Plugin Manager
- **[folke/lazy.nvim](https://github.com/folke/lazy.nvim)** – Plugin manager that lazy-loads plugins for faster startup

### LSP & Language Support
- **[neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)** – Configurations for Language Server Protocol (LSP) servers
- **[williamboman/mason.nvim](https://github.com/williamboman/mason.nvim)** – Portable package manager for LSP servers, linters, formatters
- **[williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim)** – Bridge between Mason and nvim-lspconfig
- **[SmiteshP/nvim-navic](https://github.com/SmiteshP/nvim-navic)** – Displays current code context in statusline (breadcrumbs)
- **[nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)** – Syntax highlighting and parsing via Tree-sitter
- **[nvim-treesitter/nvim-treesitter-textobjects](https://github.com/nvim-treesitter/nvim-treesitter-textobjects)** – Text objects for Tree-sitter

### UI & Appearance
- **[rebelot/kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim)** – Colorscheme (Kanagawa-wave variant)
- **[nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)** – Statusline with custom Eviline configuration
- **[akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim)** – Tabline for buffers with Neo-tree integration
- **[lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)** – Indentation guides with custom character
- **[nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)** – Icons for various plugins (Neo-tree, Telescope, etc.)

### Navigation & File Management
- **[nvim-neo-tree/neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)** – File explorer with custom sorting and auto-close behavior
- **[nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)** – Fuzzy finder for files, grep, git, LSP
- **[folke/flash.nvim](https://github.com/folke/flash.nvim)** – Enhanced motion with jump labels
- **[s1n7ax/nvim-window-picker](https://github.com/s1n7ax/nvim-window-picker)** – Window selection with visual hints
- **[antosha417/nvim-lsp-file-operations](https://github.com/antosha417/nvim-lsp-file-operations)** – LSP-aware file operations (rename, move, delete)

### Git Integration
- **[lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)** – Git signs in the gutter, line blame, hunk operations
- **[tpope/vim-fugitive](https://github.com/tpope/vim-fugitive)** – Git wrapper with Telescope integration for commits/blame/status

### Autocompletion & Editing
- **[saghen/blink.cmp](https://github.com/saghen/blink.cmp)** – Autocompletion engine with Rust backend
- **[numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim)** – Smart commenting with `gcc` and `gc` motions

### Diagnostics & Troubleshooting
- **[folke/trouble.nvim](https://github.com/folke/trouble.nvim)** – Pretty diagnostics, references, and quickfix lists
- **[folke/snacks.nvim](https://github.com/folke/snacks.nvim)** – LazyVim dependency (required for LazyVim to function)

### Testing
- **[nvim-neotest/neotest](https://github.com/nvim-neotest/neotest)** – Extensible testing framework
- **[nvim-neotest/neotest-go](https://github.com/nvim-neotest/neotest-go)** – Go adapter for neotest
- **[nvim-neotest/nvim-nio](https://github.com/nvim-neotest/nvim-nio)** – Async I/O library for neotest

### Utilities & Dependencies
- **[nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)** – Utility library used by Telescope, Neo-tree, neotest
- **[MunifTanjim/nui.nvim](https://github.com/MunifTanjim/nui.nvim)** – UI component library for Neo-tree
- **[OXY2DEV/markview.nvim](https://github.com/OXY2DEV/markview.nvim)** – Markdown preview with split view toggle
- **[LazyVim/LazyVim](https://github.com/LazyVim/LazyVim)** – Preconfigured Neovim setup (partially used for colorscheme configuration)

### Total: 30 plugins

**Note**: All plugins are managed via `lazy.nvim` with configuration split across modular files in `dot-config/nvim/lua/plugins/`. The plugin versions are locked in `dot-config/nvim/lazy-lock.json`.