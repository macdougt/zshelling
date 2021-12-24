eval "$(/opt/homebrew/bin/brew shellenv)"


export UTILS="$HOME/data/utils"
export PYTHON="python3"

# Source wrapper that reports processing
function sourcery() {
    source $1
    echo "Processed $1"
}

# Pull in the other dot content
# *Must be idempotent
sourcery $HOME/.aliases
sourcery $HOME/.bbh_content
sourcery $HOME/.docker_content
sourcery $HOME/.dirh_content
sourcery $HOME/.zpaths

# TODO Look into the options
setopt extendedglob

# Override cd - change directory
function cd() {
   if [ -f "$*" ]
   then
      dir=$(dirname $*)
      builtin cd "$dir" && $PYTHON $UTILS/appendif.py "`pwd`";
   else
      if [ -z "$*" ]; then
        builtin cd ${HOME} && $PYTHON $UTILS/appendif.py "`pwd`";
      else
        builtin cd "$*" && $PYTHON $UTILS/appendif.py "`pwd`";
      fi
   fi
}
#export -f cd

cdd () {
    if [ -z "$1" ]; then
        dirHistoryFunction;
    else
        $PYTHON $UTILS/DirectoryHistory.py do $* && cd `cat /tmp/yo808`;
    fi
}

# Completions
if type brew &>/dev/null; then
FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

autoload -Uz compinit
compinit
fi

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
