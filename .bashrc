# ~/.bashrc

source ~/.secrets.env

if command -v apt >/dev/null 2>&1 && ! command -v eza >/dev/null 2>&1; then
    sudo apt install eza micro
fi

if command -v pacman >/dev/null 2>&1 && ! command -v eza >/dev/null 2>&1; then
    sudo pacman -S eza micro
fi

if command -v dnf >/dev/null 2>&1 && ! command -v eza >/dev/null 2>&1; then
    sudo dnf install eza micro
fi

if command -v zypper >/dev/null 2>&1 && ! command -v eza >/dev/null 2>&1; then
    sudo zypper install eza micro
fi

### START FUNCTIONS ###

please() {
    FC=$(history -p !!)
    if [ -z "$1" ]; then
        sudo $FC
    else
        sudo "$@"
    fi
}

fuck() {
    please "$@"
}

mpcplay() {
    if [ -z "$1" ]; then
        echo "Usage: mpcplay <folder>"
        echo "Folder path should be relative to ~/Music/"
        return 1
    fi

    mpc clear
    mpc add "${1#~/Music/}"  # Remove ~/Music/ prefix if user included it
    mpc random on
    mpc play
}

tmr() {
    if [ $# -eq 0 ]; then
        echo "Usage: tmr <duration>"
        return 1
    fi

    # Run termdown and capture its exit status
    termdown "$@"
    termdown_status=$?

    # Only play the sound if termdown was successful
    if [ $termdown_status -eq 0 ]; then
        # Suppress all output from mpg123
        mpg123 --loop -1 ~/.sounds/w10clock.mp3 > /dev/null 2>&1
    else
        echo "termdown failed or was interrupted"
        return $termdown_status
    fi
}

yt-fhd() {
    if [ $# -eq 0 ]; then
        echo "Usage: yt-fhd <YouTube URL>"
        return 1
    fi

    yt-dlp -f 'bestvideo[height<=1080][ext=mp4]+bestaudio[ext=m4a]/best[height<=1080][ext=mp4]/best[ext=mp4]/best' \
           -o '%(title)s.%(ext)s' \
           "$1"
}

yt-hd() {
    if [ $# -eq 0 ]; then
        echo "Usage: yt-hd <YouTube URL>"
        return 1
    fi

    yt-dlp -f 'bestvideo[height<=720][ext=mp4]+bestaudio[ext=m4a]/best[height<=720][ext=mp4]/best[ext=mp4]/best' \
           -o '%(title)s.%(ext)s' \
           "$1"
}

yt-sd() {
    if [ $# -eq 0 ]; then
        echo "Usage: yt-sd <YouTube URL>"
        return 1
    fi

    yt-dlp -f 'bestvideo[height<=480][ext=mp4]+bestaudio[ext=m4a]/best[height<=480][ext=mp4]/best[ext=mp4]/best' \
           -o '%(title)s.%(ext)s' \
           "$1"
}

yt-mp3() {
    yt-dlp \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        --metadata-from-title "%(artist)s - %(title)s" \
        --parse-metadata "title:%(title)s" \
        --parse-metadata "artist:%(artist)s" \
        --parse-metadata "album:%(album)s" \
        --parse-metadata "date:%(release_date)s" \
        --parse-metadata "description:%(description)s" \
        --parse-metadata "genre:%(genre)s" \
        --parse-metadata "comment:%(webpage_url)s" \
        --output "%(title)s.%(ext)s" \
        "$@"
}

yt-mp3-list() {
    yt-dlp \
        --extract-audio \
        --audio-format mp3 \
        --audio-quality 0 \
        --embed-thumbnail \
        --add-metadata \
        --metadata-from-title "%(artist)s - %(title)s" \
        --parse-metadata "title:%(title)s" \
        --parse-metadata "artist:%(artist)s" \
        --parse-metadata "album:%(album)s" \
        --parse-metadata "date:%(release_date)s" \
        --parse-metadata "description:%(description)s" \
        --parse-metadata "genre:%(genre)s" \
        --parse-metadata "comment:%(webpage_url)s" \
        --output "%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s" \
        --yes-playlist \
        --playlist-start 1 \
        "$@"
}

### END FUNCTIONS ###

### EXPORT
export TERM="xterm-256color"                      # getting proper colors
export TERMINAL="/bin/alacritty"
export HISTCONTROL=ignoredups:erasedups           # no duplicate entries

### SET MANPAGER
### Uncomment only one of these!

### "nvim" as manpager
export MANPAGER="nvim +Man!"

### "less" as manpager
# export MANPAGER="less"

### SET VI MODE ###
# Comment this line out to enable default emacs-like bindings
#set -o vi
#bind -m vi-command 'Control-l: clear-screen'
#bind -m vi-insert 'Control-l: clear-screen'

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
PATH="\
/bin:\
/sbin:\
/usr/bin:\
/usr/sbin:\
/usr/local/bin:\
$HOME/.bin:\
$HOME/.local/bin:\
$HOME/.cargo/bin:\
$HOME/.local/src/dwmblocks/scripts:\
"

### SETTING OTHER ENVIRONMENT VARIABLES
if [ -z "$XDG_CONFIG_HOME" ] ; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ] ; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ] ; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi
export XMONAD_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
export XMONAD_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
export XMONAD_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

### CHANGE TITLE OF TERMINALS
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|alacritty|st|konsole*)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
        ;;
  screen*)
    PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    ;;
esac

### SHOPT
shopt -s autocd # change to named directory
shopt -s cdspell # autocorrects cd misspellings
shopt -s cmdhist # save multi-line commands in history as single line
shopt -s dotglob
shopt -s histappend # do not overwrite history
shopt -s expand_aliases # expand aliases
shopt -s checkwinsize # checks term size when bash regains control

#ignore upper and lowercase when TAB completion
bind "set completion-ignore-case on"

### COUNTDOWN   
cdown () {
    N=$1
  while [[ $((--N)) -gt  0 ]]
    do
        echo "$N" |  figlet -c | lolcat &&  sleep 1
    done
}

### Function extract for common file formats ###
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

### ARCHIVE EXTRACTION
# usage: ex <file>
function ex {
 if [ -z "$1" ]; then
    # display usage if no parameters given
    echo "Usage: ex <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
 else
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                         tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                         7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                         echo "ex: '$n' - unknown archive method"
                         return 1
                         ;;
          esac
      else
          echo "'$n' - file does not exist"
          return 1
      fi
    done
fi
}

IFS=$SAVEIFS

# navigation
up () {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
  fi
}

### ALIASES ###
# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# vim and emacs
alias vim="nvim"
alias nano="micro"

# Changing "ls" to "eza"
alias ls='eza -al --color=always --hyperlink --group-directories-first' # my preferred listing
alias la='eza -a --color=always --hyperlink --group-directories-first'  # all files and dirs
alias ll='eza -l --color=always --hyperlink --group-directories-first'  # long format
alias lt='eza -aT --color=always --hyperlink --group-directories-first' # tree listing
alias l.='eza -al --color=always --hyperlink --group-directories-first ../' # ls on the PARENT directory
alias l..='eza -al --color=always --hyperlink --group-directories-first ../../' # ls on directory 2 levels up
alias l...='eza -al --color=always --hyperlink --group-directories-first ../../../' # ls on directory 3 levels up

# pacman and yay
alias pacsyu='sudo pacman -Syu'                  # update only standard pkgs
alias pacsyyu='sudo pacman -Syyu'                # Refresh pkglist & update standard pkgs
alias parsua='paru -Sua --noconfirm'             # update only AUR pkgs (paru)
alias parsyu='yay -Syu --noconfirm'             # update standard pkgs and AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # remove pacman lock
alias orphan='sudo pacman -Rns $(pacman -Qtdq)' # remove orphaned packages (DANGEROUS!)

# get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# adding flags
alias df='df -h'               # human-readable sizes
alias free='free -m'           # show sizes in MB
alias grep='grep --color=auto' # colorize output (good for log files)

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Merge Xresources
alias merge='xrdb -merge ~/.Xresources'

# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias stat='git status'  # 'status' is protected name so using 'stat' instead
alias tag='git tag'
alias newtag='git tag -a'

# get error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# gpg encryption
# verify signature for isos
alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
# receive the key of a developer
alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

# change your default USER shell
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Log out and log back in for change to take effect.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Log out and log back in for change to take effect.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo 'Log out and log back in for change to take effect.'"

alias sxhkd-reload="sudo killall sxhkd; sxhkd &"
alias shi="history | grep "
alias dhi='history -d $((HISTCMD-1)) && history -d $((HISTCMD-1))' #strike last line from ~/.bash_history
# bare git repo alias for managing my dotfiles
alias config="/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME"
alias configqc='/usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME add -u && /usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME commit -m "autocommit" && /usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME push'
alias gitqc='git add -u && git commit -m "autocommit" && git push'

alias ep="nvim $HOME/.bashrc && source $HOME/.bashrc && /usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME add -u && /usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME commit -m 'autocommit' && /usr/bin/git --git-dir=$HOME/git/dotfiles --work-tree=$HOME push"
alias vol="pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1"
alias volv="echo \"Vol: $(pactl list sinks | grep '^[[:space:]]Volume:' | head -n1 | awk '{print $5}')\""
# termbin
alias tb="nc termbin.com 9999"
alias clock="tty-clock -s -c"
# misc
alias weather='clear && curl wttr.in'
alias ltfo='pkill -u $USER'

#dwm
alias startup="nvim $HOME/.local/share/dwm/autostart.sh"
alias dwmdeps="nvim $HOME/.local/share/dwm/autostart-blocking.sh"
alias edwm="nvim $HOME/.local/src/dwm-flexipatch/config.h"
alias pdwm="nvim $HOME/.local/src/dwm-flexipatch/patches.h"
alias cdwm="pushd $HOME/.local/src/dwm-flexipatch && sudo make clean install; popd"
alias edwmbl="nvim $HOME/.local/src/dwmblocks/config.h"
alias cdwmbl="pushd $HOME/.local/src/dwmblocks && sudo make clean install; popd"
alias cddwmbl="cd $HOME/.local/src/dwmblocks"
alias tarver='read -p "Version number: " ver && tar --zstd -cf "../$(basename $(pwd))-v${ver}.tar.zst" .'
. "$HOME/.cargo/env"
