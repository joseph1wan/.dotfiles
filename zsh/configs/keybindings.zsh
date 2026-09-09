# give us access to ^Q
stty -ixon

# match macOS-native word boundaries (Option+Delete/Left/Right stop at
# '.', '/', '-' instead of treating "git.autodesk.com" as one word)
WORDCHARS=${WORDCHARS//[.\/-]}

# handy keybindings
bindkey "^Y" accept-and-hold
bindkey "^N" insert-last-word
bindkey "^Q" push-line-or-edit
bindkey -s "^T" "^[Isudo ^[A" # "t" for "toughguy"

# Forces Zsh's default typing mode to catch the Escape+Backspace sequence
# and delete a word instead of dropping into Vim mode
bindkey '^[^?' backward-kill-word
bindkey '\e\x7f' backward-kill-word

# macOS-native Option+Left/Right to move by word
bindkey '\e[1;9D' backward-word
bindkey '\e[1;9C' forward-word
bindkey '\e\x1b[D' backward-word
bindkey '\e\x1b[C' forward-word
bindkey '\eb' backward-word
bindkey '\ef' forward-word
