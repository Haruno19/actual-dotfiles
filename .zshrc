#*** EXPORT ***#

export ZSH="$HOME/.oh-my-zsh"
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk@11/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
export PATH="/opt/homebrew/opt/python@3.9/Frameworks/Python.framework/Versions/3.9/bin:/Users/haru/Library/Python/3.9/bin:$PATH"

#*** ZSH ***#

plugins=(
  zsh-autosuggestions
  zsh-syntax-highlighting
)
ZSH_THEME="aditya" # set by `omz`
source $ZSH/oh-my-zsh.sh
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


#*** FUNCTIONS ***#

code () { VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $* ;}

#*** ALIAS ***#

alias gncc="/opt/homebrew/bin/gcc-13"
alias gn++="/opt/homebrew/bin/g++-13"
alias cd=z

#*** EVALS ***#

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"
