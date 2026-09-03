# load custom executable functions
for function in ~/.zsh/functions/*; do
  source $function
done

# extra files in ~/.zsh/configs/pre , ~/.zsh/configs , and ~/.zsh/configs/post
# these are loaded first, second, and third, respectively.
_load_settings() {
  _dir="$1"
  if [ -d "$_dir" ]; then
    if [ -d "$_dir/pre" ]; then
      for config in "$_dir"/pre/**/*~*.zwc(N-.); do
        . $config
      done
    fi

    for config in "$_dir"/**/*(N-.); do
      case "$config" in
        "$_dir"/(pre|post)/*|*.zwc)
          :
          ;;
        *)
          . $config
          ;;
      esac
    done

    if [ -d "$_dir/post" ]; then
      for config in "$_dir"/post/**/*~*.zwc(N-.); do
        . $config
      done
    fi
  fi
}
_load_settings "$HOME/.zsh/configs"

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

setopt auto_cd

export GOPATH=~/go
[ -d /Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home ] && export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home
export PATH="$PATH:$HOME/.local/bin"

if [ -f /opt/homebrew/share/antigen/antigen.zsh ]; then
  source /opt/homebrew/share/antigen/antigen.zsh

  # Load the oh-my-zsh's library
  antigen use oh-my-zsh

  antigen bundle agkozak/zsh-z
  antigen bundle zsh-users/zsh-autosuggestions
  antigen bundle zsh-users/zsh-completions
  antigen bundle zsh-users/zsh-syntax-highlighting

  # Load the theme
  antigen theme denysdovhan/spaceship-prompt

  ### Fix slowness of pastes with zsh-syntax-highlighting.zsh
  pasteinit() {
    OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
    zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
  }
  pastefinish() {
    zle -N self-insert $OLD_SELF_INSERT
  }
  zstyle :bracketed-paste-magic paste-init pasteinit
  zstyle :bracketed-paste-magic paste-finish pastefinish

  # Tell antigen that you're done
  antigen apply
fi

eval "$(fzf --zsh)"
eval "$(pyenv init --path)"
# eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"
[ -f "${DOTFILES_DIR:-$HOME/.dotfiles}/adsk/zshrc.sh" ] && source "${DOTFILES_DIR:-$HOME/.dotfiles}/adsk/zshrc.sh"

# Optional untracked, machine-local overrides (secrets, etc.) — not part of
# this repo, not symlinked by install.sh.
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local

# aliases
[[ -f ~/.aliases ]] && source ~/.aliases
