#   -----------------------------
#   MAKE TERMINAL BETTER
#   -----------------------------

cd() { builtin cd "$@"; ls; }               # Always list directory contents upon 'cd'
alias c="cd"
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias ~="cd ~"                              # ~:            Go Home
alias l='ls'
alias ll='ls -FGlAhp'
alias ls='ls -G'                            # ls showing colors

alias gcfd="git clean -fd"
alias br="bin/rspec"
alias sbash="source ~/.bash_profile"

#   -----------------------------
#   NAVIGATION
#   -----------------------------

alias am="cd ~/automatica"
alias docs="cd ~/aspera_tools/docs-dita"
alias tools="cd ~/aspera_tools/internal_tools"
alias .dot="cd ~/.dotfiles"

#   -----------------------------
#   EDIT CONFIG FILES
#   -----------------------------

alias v="vim"
alias bp="vim ~/.bash_profile"
alias vrc="vim ~/.vimrc"
alias vplug="vim ~/.vim/plugins.vim"
alias virc="vim ~/.ideavimrc"
alias vc="vim ~/.vim/cheatsheet.txt"
alias vgb="vim build_external/build_scripts/general.build.rb"
alias vgc="vim ~/.gitconfig"

#   -----------------------------
#   APPLICATION SHORTCUTS
#   -----------------------------

alias aspera="~/aspera_tools/.mount_aspera.sh"
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder

#   -----------------------------
#   GIT ALIASES
#   -----------------------------

# update_b(){
#   git pull
#   for folder in $(echo *_external); do
#     echo $folder;
#    (builtin cd $folder && git pull);
#   done
# }

# gcol() {

#   branch=cmd("ls | grep /\d.\d.\d/
#       | sort 
#       | uniq -c
#       | sort -r -k1 -n
#       | awk '{print $2" "$1}'" )
#   "git checkout ${branch}"
# }
alias gs="git status"
alias gconf="subl ~/.gitconfig"
alias gp="git pull"
alias gps="git push"
alias gpsb="git push; jbuild"
alias gpsbr="git push; jbuild -r"

#   -----------------------------
#   GIT SCRIPTS
#   -----------------------------

tools_path="~/aspera_tools/internal_tools/scripts"

alias lbuild="ruby $tools_path/run_test_build.rb"
alias update="ruby $tools_path/update_repos.rb"
alias checkout="ruby $tools_path/checkout_repos.rb"
alias external="ruby $tools_path/configure_externals.rb"
alias add_module="ruby ~/aspera_tools/authoring_tools/add_module_to_file.rb"

#   -----------------------------
#   BUILD SCRIPTS
#   -----------------------------

alias jbuild="ruby $tools_path/run_builds.rb"
alias jconf="ruby $tools_path/configure_jenkins_build.rb"
alias p2prod="ruby $tools_path/push_to_prod.rb"

#   -----------------------------
#   DOCS SCRIPTS
#   -----------------------------

alias transform_images="ruby $tools_path/docs/transform_images.rb"

#   -----------------------------
#   COLORS
#   -----------------------------
export LSCOLORS='gxxxxxxxxxxxxxxxxxxxxx'    # Directories appear in blue

#   -----------------------------
#   PATHS & EXPORTS
#   -----------------------------

export PATH="$(brew --prefix qt@5.5)/bin:$PATH"

# Gitaware Prompt
export GITAWAREPROMPT=~/.bash/git-aware-prompt
source "${GITAWAREPROMPT}/main.sh"
export PS1="\u@\h \W \[$txtcyn\]\$git_branch\[$txtred\]\$git_dirty\[$txtrst\]\$ "

eval "$(rbenv init -)"

[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
