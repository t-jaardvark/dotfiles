My dotfiles, along with how I setup my boxes. 

### pre-setup
- install nix package manager (to install dependencies)
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon
nix-env -iA nixpkgs.eza
nix-env -iA nixos.starship
nix-env -iA nixos.neovim
nix-env -iA nixos.micro
```
### setup (overwite current dotfiles)
```bash
mkdir -p ~/git/
git clone --bare https://github.com/t-jaardvark/dotfiles.git ~/git/dotfiles
alias config="/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME"
/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME checkout

# Reload shell configuration based on the current shell
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
elif [ -n "$FISH_VERSION" ]; then
    source ~/.config/fish/config.fish
fi
```
