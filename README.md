# My dotfiles + how I setup my boxes. 

### pre-setup
- install nix package manager
```bash
sh <(curl -L https://nixos.org/nix/install) --daemon --yes
```
- restart terminal and then install dependencies
```bash
nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.eza
nix-env -iA nixpkgs.starship
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.micro
nix-env -iA nixpkgs.fish
nic-env -iA nixpkgs.tmux
```

### setup (overwite current dotfiles)
```bash
rm ~/.bashrc
mkdir -p ~/git/
git clone --bare https://github.com/t-jaardvark/dotfiles.git ~/git/dotfiles
/usr/bin/env git --git-dir=$HOME/git/dotfiles --work-tree=$HOME checkout

# Reload shell configuration based on the current shell
if [ -n "$BASH_VERSION" ]; then
    source ~/.bashrc
elif [ -n "$ZSH_VERSION" ]; then
    source ~/.zshrc
elif [ -n "$FISH_VERSION" ]; then
    source ~/.config/fish/config.fish
fi
```
