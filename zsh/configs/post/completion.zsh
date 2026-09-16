# load our own completion functions
fpath=(~/.zsh/completion /usr/local/share/zsh/site-functions $fpath)

# completion; use cache if updated within 24h
autoload -Uz compinit
if [[ -n $HOME/.zcompdump(#qN.mh+24) ]]; then
  compinit -d $HOME/.zcompdump;
else
  compinit -C;
fi;

# disable zsh bundled function mtools command mcd
# which causes a conflict. compinit skips defining compdef if it found
# insecure (group/world-writable) directories in $fpath — see init.sh.
(( $+functions[compdef] )) && compdef -d mcd
