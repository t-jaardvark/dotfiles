My dotfiles

# setup (overwite current dotfiles
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
