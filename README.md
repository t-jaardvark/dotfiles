# My dotfiles + how I setup my boxes. 

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
