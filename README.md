# Dotfiles Configuration

This repository contains my personal dotfiles, with a focus on **Neovim** and **Tmux** configurations. Additional configurations for Zsh and Ghostty are also included but optional. The configurations are managed using [GNU Stow](https://www.gnu.org/software/stow/) for easy symlinking.

## Structure

```
dotfiles/
├── .stow-local-ignore
├── dot-tmux.conf          # tmux configuration
├── dot-zshrc              # zsh configuration
└── dot-config/            # configuration files for ~/.config
    ├── nvim/              # Neovim configuration (LazyVim based)
    └── ghostty/         # Ghostty terminal emulator config
```

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) installed on your system.

### Installing Stow

- **macOS (Homebrew)**: `brew install stow`
- **Ubuntu/Debian**: `sudo apt install stow`
- **Fedora**: `sudo dnf install stow`
- **Arch**: `sudo pacman -S stow`

### Installing Zsh and Plugins (Linux)

If you plan to use the Zsh configuration, install these packages:

- **Zsh**: `sudo apt install zsh`
- **zsh-autosuggestions**: `sudo apt install zsh-autosuggestions`
- **zsh-syntax-highlighting**: `sudo apt install zsh-syntax-highlighting`
- **eza** (modern ls replacement): `sudo apt install eza` or via cargo: `cargo install eza`
- **zoxide** (smart cd): `sudo apt install zoxide` or via cargo: `cargo install zoxide`

The `.zshrc` file will automatically detect the correct paths for these plugins.

## Installation

You have two options: either use the existing structure with explicit stow commands, or reorganize the repository for a more standard stow workflow. The second method is recommended for simplicity and maintainability.

### Method 1: Using the Current Structure

This method uses the existing `dot-` prefix files and `dot-config` directory. You will need to run stow with explicit target directories.

1. Clone this repository to your desired location (e.g., `~/.dotfiles`):

   ```bash
   git clone <repository-url> ~/.dotfiles
   cd ~/.dotfiles
   ```

2. Link the configurations:

   > **Note**: The following steps cover tmux, zsh, and neovim. If you only need neovim and tmux, you can skip the zsh step. The neovim step also links ghostty; see the note below.

   - **tmux** (creates `~/.tmux.conf`):

     ```bash
     ln -sf "$PWD/dot-tmux.conf" ~/.tmux.conf
     ```

     Alternatively, use stow with a temporary directory:

     ```bash
     mkdir -p tmux && cp dot-tmux.conf tmux/.tmux.conf
     stow -t ~ tmux
     rm -rf tmux
     ```

   - **zsh** (creates `~/.zshrc`):

     ```bash
     ln -sf "$PWD/dot-zshrc" ~/.zshrc
     ```

   - **Neovim** (creates `~/.config/nvim`):

     ```bash
     stow -t ~/.config dot-config
     ```

     This will symlink **all** subdirectories under `dot-config` (nvim, ghostty) into `~/.config`. If you only want Neovim, move the ghostty directory out of `dot-config` before running stow.

3. **Important**: If you already have existing configuration files or directories in the target locations, you must back them up first. Stow will refuse to overwrite non‑symlink directories.

### Method 2: Reorganize for Standard Stow Usage (Recommended)

This method reorganizes the repository into a structure that stow can process directly, without extra flags or manual symlinks. The changes are minimal and keep the original files intact. **Note**: The `zsh` package is optional; if you only need neovim and tmux, you can skip stowing it.

1. Inside the repository, create the following directories:

   ```bash
   mkdir -p tmux zsh config
   ```

2. Move the configuration files into the appropriate directories:

   ```bash
   mv dot-tmux.conf tmux/.tmux.conf
   mv dot-zshrc zsh/.zshrc
   mv dot-config/* config/
   rmdir dot-config
   ```

   The layout now becomes:

   ```
   dotfiles/
   ├── .stow-local-ignore
   ├── tmux/
   │   └── .tmux.conf
   ├── zsh/
   │   └── .zshrc
   └── config/
       ├── nvim/
       └── ghostty/
   ```

   > The `config` package includes nvim and ghostty. If you only need nvim, you can remove the ghostty subdirectory before stowing.

3. Now you can stow each package individually:

   ```bash
   stow -t ~ tmux        # creates ~/.tmux.conf
   stow -t ~ zsh         # creates ~/.zshrc
   stow -t ~/.config config   # creates ~/.config/nvim, ~/.config/ghostty, etc.
   ```

   To stow everything at once (excluding the scripts directory):

   ```bash
   stow -t ~ tmux zsh
   stow -t ~/.config config
   ```

4. If you later update the repository, simply run the same stow commands again—stow will safely update the symlinks.

## Removing Symlinks

To remove the symlinks (un‑stow) a package, use the `-D` flag:

```bash
stow -D -t ~ tmux
stow -D -t ~ zsh
stow -D -t ~/.config config
```

## Notes

- The `.stow-local-ignore` file ensures that the `scripts/` directory (if present) is never linked. You can edit this file to ignore other files or directories.
- The Neovim configuration is based on [LazyVim](https://www.lazyvim.org/). Refer to the `nvim/` directory for plugin details.
- Always review configuration files before linking, especially shell rc files, to avoid conflicts with your existing setup.

## Troubleshooting

- **Stow fails with "cannot stow directory: directory already exists"**: This means there is a real directory (not a symlink) in the target location. Move or rename that directory, then run stow again.
- **Symlinks point to the wrong location**: Ensure you are running stow from inside the dotfiles repository and that the target path (`-t`) is correct.
- **Stow is not installed**: Install stow using your package manager as shown above.

## License

This dotfiles collection is provided under the MIT License. Feel free to adapt it to your needs.