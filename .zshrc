# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt correct correctall # Enables spelling correction for commands that are mistyped and for all arguments in a command.
setopt extendedglob nocaseglob rcexpandparam numericglobsort # Enables advanced pattern matching operators, such as '!' for negation and '|' for alternation. Matches file names case-insensitively when using glob patterns. Expands parameters inside of single quotes. Sorts file names in numerical order rather than lexicographical order.
setopt appendhistory histignorealldups inc_append_history histignorespace hist_save_no_dups hist_reduce_blanks # Appends new commands to the existing history file. Ignores duplicate commands in the history file. Writes each command to the history file as it is executed, rather than only on exit. Ignores commands starting with a space character in the history file. Saves only the most recent instance of a duplicated command in the history file, and Removes extra blank lines from the history file.
setopt aliases autocd # Enables the use of aliases, which are shorthand commands or command sequences. Changes to a directory if the input provided is a valid directory path.

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias cp="cp -i" ## Enable color
alias df='df -h' ## Human readable output
alias free='free -m' ## Show output in medibytes
alias vim="vim -f" ## Force vim into the current window
alias ls='ls --color=auto' ## Force ls to use colors
eval "$(thefuck --alias)" ## Add 'the fuck' alias
alias c="clear" ## Clear the current terminal
alias q="exit" ## Exit the current shell
alias z="zcompile ~/.zshrc ; echo '.zshrc recompiled'" ## Recompile zsh as a binary source
alias bit="echo bitrate: $(/sbin/iw wlp1s0 station dump | grep 'tx bitrate' | awk '{print $3,$4}')"
alias trash="rm -rf ~/.local/share/Trash/*"
alias temp='cd $(mktemp -d)'

if [[ -r /usr/share/zsh/functions/command-not-found.zsh ]]; then
  source /usr/share/zsh/functions/command-not-found.zsh ; export PKGFILE_PROMPT_INSTALL_MISSING=1
fi

## When a command fails run thefuck
function precmd() {
  case "${?}" in
    0) : ;;
    *) fuck ;;
  esac
}
