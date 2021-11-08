# Setup fzf
# ---------
if [[ ! "$PATH" == */home/lemon/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/lemon/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/lemon/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/lemon/.fzf/shell/key-bindings.zsh"
