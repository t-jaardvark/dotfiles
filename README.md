My dotfiles


```bash
mkdir -p ~/git/
git clone --bare git@github.com:t-jaardvark/dotfiles.git ~/git/dotfiles
```

```fish
alias config="/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME"
```
