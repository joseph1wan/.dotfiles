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

eval "$(zoxide init zsh)"

_brew_prefix="$(brew --prefix)"
[ -f "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$_brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "$_brew_prefix/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh" ] && source "$_brew_prefix/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
unset _brew_prefix

eval "$(starship init zsh)"

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
# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/wanj/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions
