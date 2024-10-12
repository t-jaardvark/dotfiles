My dotfiles

# setup
```bash
mkdir -p ~/git/
git clone --bare git@github.com:t-jaardvark/dotfiles.git ~/git/dotfiles
```
alias to use as bare repo
fish
```fish
alias config="/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME"
```
