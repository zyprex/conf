#!/bin/zsh
# 'zshrc' sourced in all interactive sessions
# e.g. when opening a new terminal
ZSH_PLUGIN_DIR=$HOME/.config/zsh_plugins
# manually put any completion file into $ZSH_PLUGIN_DIR/local_completion
# this line should call before `compinit`
fpath=($ZSH_PLUGIN_DIR/local_completion $fpath)

#
# Alias:
#
alias grep='grep --color=auto --exclude-dir={.git,CVS,.svn,.idea}'
alias diff='grep --color'
alias so='source'
if [[ ! $(type exa >/dev/null) ]]; then
  alias ls='exa'
  alias ll='exa -lhF --sort extension'
  alias lh='exa -d .*'
  alias llh='exa -lhFd --sort extension .* '
else
  alias ls='ls --color=auto'
  alias ll='ls -lhF --sort extension'
  alias lh='ls -d .*'
  alias llh='ls -lhFd --sort extension .* '
fi
alias dud='du -d 1 -h'
alias duf='du -sh * | sort -h'
alias ffd='find * -type d -iname'    # find for directory
alias fff='find -L * -type f -iname' # find for file
# require confirm to use 'rm cp mv'
alias rm='rm -iv'
alias cp='cp -iv'
alias mv='mv -iv'
# quick access
alias grepenv='printenv | grep'
alias zshconfig="vim ~/.zshrc"
alias zshsource="source ~/.zshrc"
# vim
alias vimr='vim $(find * -type f -iregex "readme.*")'
# git
alias gs='git status'
alias gd='git diff'
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gac='git add --all && git commit -v'
# bulk association
alias -s {cpp,cxx,cc,c,hh,h,inl,asc,tex,TXT,txt,md}=$EDITOR
alias -s {htm,html,org,com}=$BROWSER
alias -s {jpg,jpeg,png,svg,gif,mng,tiff,tif,xpm}=$IMG_VIEWER
alias -s {pdf,PDF,epub,oxps}=$DOC_VIEWER
alias -s {avi,flv,m4a,mkv,mov,mp3,mp4,mpeg,mpg,ogg,wav}=$MEDIA_PLAYER
alias v='vim'
alias e='emacs -nw'

if [[ ! $(type timer.sh >/dev/null) ]]; then
  alias timer30m='timer.sh -1800'
  alias timer10m='timer.sh -600'
  alias timer5m='timer.sh -300'
  alias timer3m='timer.sh -180'
fi

#
# Opt:
#     https://zsh.sourceforge.io/Doc/Release/Options.html
# Opt: Changing Directories
# try cd +<tab> or cd -<tab> or dirs -v
setopt AUTO_CD           # go to folder path without using cd.
setopt AUTO_PUSHD        # push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS # do not store duplicates in the stack.
setopt PUSHD_MINUS       # exchanges the meanings of ‘+’ and ‘-’
setopt PUSHD_SILENT      # do not print the directory stack after pushd or popd.
setopt CORRECT           # spelling correction
setopt CDABLE_VARS       # change directory to a path stored in a variable.
setopt EXTENDED_GLOB     # use extended globbing syntax.
# Opt: Completion
# setopt MENU_COMPLETE   # autoselect the first completion entry, cancel select use [ctrl+g]
setopt FLOWCONTROL
setopt AUTO_MENU       # show completion menu on successive tab press
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
# Opt: History
setopt EXTENDED_HISTORY       # write the history file in the ':start:elapsed;command' format.
setopt SHARE_HISTORY          # share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST # expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS       # do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS   # delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS      # do not display a previously found event.
setopt HIST_IGNORE_SPACE      # do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS      # do not write a duplicate event to the history file.
setopt HIST_VERIFY            # do not execute immediately upon history expansion.
setopt HIST_REDUCE_BLANKS     # remove suprefluous blanks

#
# functions
#
mkdircd(){
  mkdir -p $1 && cd $1
}
catless(){
  # cat use less only when file lines exceed term lines.
  if [[ -n $(sed -n "$(tput lines)p" $1) ]]; then
    cat $1 | less
  else
    cat $1
  fi
}
dir-stack-push(){
export DIR_STACKS=$DIR_STACKS:$PWD # push current path to CD_STACKS
cd ..
zle reset-prompt                   # redraw prompt
}
dir-stack-pop(){
if [[ -z ${DIR_STACKS##*:} ]]; then
  return                           # don't cd to home path
fi
cd ${DIR_STACKS##*:}               # cd last path
zle reset-prompt                   # redraw prompt
export DIR_STACKS=${DIR_STACKS%:*} # remove last path
}
zle -N dir-stack-push
zle -N dir-stack-pop
# ranger
ranger-cd(){
source ranger
}
# fzf
# ^prefix-exact-match suffix-exact-match$ 'exact-match !inverse-exact-match
# " " = AND   "|" = OR (higher precedence)
# fzf-history() { eval $(fc -lrn 1 | fzf) }
fzf-ps() {
echo $(ps axo user,pid,comm | fzf) 
}
fzf-vim(){
vim $(fzf --multi --preview="cat {}" --preview-window=down)
}
fzf-pacman-install(){
pacman -Slq | fzf --multi --preview 'pacman -Si {1}'| xargs -ro sudo pacman -S
}
fzf-pacman-uninstall(){
pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}
fzf-flatpak-install(){
flatpak search --columns=application . | fzf --multi | xargs -ro flatpak install 
}
fzf-flatpak-uninstall(){
flatpak list --columns=application | fzf --multi --preview \
  'flatpak info {1}' | xargs -ro flatpak uninstall
flatpack uninstall --unused
}
# xx - list whats inside archive file
# usage: xx <file>
xx(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar tf    $1;;
      *.tar.gz)  echo      $1;;
      *.rar)     unrar l   $1;;
      *.gz)      gunzip -l $1;;
      *.tar)     tar tf    $1;;
      *.tbz2)    tar tf    $1;;
      *.tgz)     tar tf    $1;;
      *.zip)     unzip -l  $1;;
      *.7z)      7z l      $1;;
      *.ace)     unace l   $1;;
      *) echo "'$1' cannot be extracted test via xx()";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# ex - archive extractor
# usage: ex <file>
ex(){
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2) tar xjf    $1;;
      *.tar.gz)  tar xzf    $1;;
      *.bz2)     bunzip2    $1;;
      *.rar)     unrar x    $1;;
      *.gz)      gunzip     $1;;
      *.tar)     tar xf     $1;;
      *.tbz2)    tar xjf    $1;;
      *.tgz)     tar xzf    $1;;
      *.zip)     unzip      $1;;
      *.Z)       uncompress $1;;
      *.7z)      7z x       $1;;
      *) echo "'$1' cannot be extracted via ex()";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}
# xe - archive compress
xe(){
  case $1 in
    *.tar.bz2) tar -cvf "$@";;
    *.tar.gz)  tar -cvf "$@";;
    *.rar)     rar a    "$@";;
    *.zip)     zip -r   "$@";;
    *.7z) 7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on "$@";;
    *) echo "Usage: xe [archive_name] [files]\nPossible archive extension:
- tar.bz2\n- tar.gz\n- rar\n- zip\n- 7z";;
  esac
}
# color man page
man(){
  LESS_TERMCAP_md=$'\e[01;31m'   \
    LESS_TERMCAP_me=$'\e[0m'     \
    LESS_TERMCAP_us=$'\e[01;32m' \
    LESS_TERMCAP_ue=$'\e[0m'     \
    LESS_TERMCAP_so=$'\e[45;93m' \
    LESS_TERMCAP_se=$'\e[0m'     \
    command man "$@"
  }
# trash bin: move file to /tmp/.trash/, that gets cleared on each reboot
trash(){
  mkdir -p /tmp/.trash && mv -iv "$@" /tmp/.trash;
}
# checks for existence of a command (0 = true, 1 = false)
# type_exists() { [ "$(type -p "$1")" ] }
# source exist script 
# sox{}{ test -f $1 && source $1 }

#
# bindkey
#
# tips1: see all keybindings use $ bindkey
# tips2: see anykey keycode use `Ctrl + v + anykey`
# useful keybind:
# "^x^v" vi-cmd-mode
# "^x^f" vi-find-next-char
# "^x^x" exchange-point-and-mark
# "^xa"  _expand_alias
# "^[a"  accept-and-hold
# "^[s"  spell-word
# "^[q"  push-line
# "^[."  insert-last-word
bindkey -e 
bindkey -M emacs "^ " magic-space     # [ctrl + space]
bindkey '^[[Z' reverse-menu-complete  # [shift + tab]
bindkey '^[k' dir-stack-push          # [Alt + k]
bindkey '^[j' dir-stack-pop           # [Alt + j]
bindkey '^[m' copy-prev-shell-word    # [Alt + m]
bindkey -s '^[/' 'ls'           # [Alt + /]
bindkey -s '^[OP' 'apropos \n'      # [F1]
# edit the current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line
# load fzf key bindings
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

#
# prompt
#
ZSHPS_UNAME='%F{green}%n%f'
ZSHPS_HOST='%F{magenta}%m%f'
ZSHPS_CWD='%F{blue}%B%~%b%f'
ZSHPS_ERRNO='%(?..(%K{white}%F{red}%?%f%k%))'
PS1=$ZSHPS_UNAME'@'$ZSHPS_HOST' '$ZSHPS_CWD' '$ZSHPS_ERRNO'> '
case $TERM in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    # precmd () is a function which is executed just before each prompt
    precmd(){
      # set term title
      print -Pn "\e]0;%n@%m:%~\a"
      RPS1=
      ZSHPS_GIT_BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null)
      ZSHPS_GIT_HEAD=$(git rev-parse --short HEAD 2>/dev/null)
      if [[ -n $ZSHPS_GIT_BRANCH ]]; then
        RPS1=${ZSHPS_GIT_BRANCH}'/'${ZSHPS_GIT_HEAD}
      elif [[ -n ZSHPS_GIT_HEAD ]]; then
        RPS1=${ZSHPS_GIT_HEAD}
      fi
    }
    # chpwd () is a function which is executed whenever the directory is changed
    chpwd(){}
  ;;
  screen*)
  ;;
esac

#
# completion
#
zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit     && compinit     # initialize the completion
autoload -Uz bashcompinit && bashcompinit # initialize bash completion
zstyle ':completion:*' use-cache on
# zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# usual completion, then case-insensitive completion, then partial words completion
# zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' verbose yes
zstyle ':completion:*:parameters' extra-verbose yes
zstyle ':completion:*' group-name '' # group the different type of matches under their descriptions
zstyle ':completion:*' group-order \
  expansions options aliases functions builtins reserved-words \
  executables local-directories directories suffix-aliases
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:*:cp:*' file-sort size
zstyle ':completion:*:*:cd:*' tag-order \
  directory-stack local-directories path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
# enable color support of ls
# http://www.bigsoft.co.uk/blog/2008/04/11/configuring-ls_colors
[[ -f ~/.dir_colors ]] && eval $(dircolors -b ~/.dir_colors)
# use ls colors in completion menu
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# unset CASE_SENSITIVE HYPHEN_INSENSITIVE

#
# plugins
#
# https://project-awesome.org/unixorn/awesome-zsh-plugins#plugins
load_plugin(){
  source $ZSH_PLUGIN_DIR/$1/$1.plugin.zsh
}
# https://github.com/zsh-users/zsh-completions
# https://github.com/marlonrichert/zsh-autocomplete
# load_plugin zsh-autocomplete
# https://github.com/zsh-users/zsh-autosuggestions
load_plugin zsh-autosuggestions
# https://github.com/zdharma/fast-syntax-highlighting
load_plugin fast-syntax-highlighting

# https://github.com/skywind3000/z.lua
eval "$(lua $ZSH_PLUGIN_DIR/z.lua/z.lua --init zsh)"

# clear useless stuff
unset -f load_plugin

