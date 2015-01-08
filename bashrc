# Tell the system to look in /usr/local first by default.
export PATH="/usr/local/bin:/usr/local/sbin:~/.bin:$PATH"

# Prefer US English and use UTF-8.
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

# Enable ruby shims and autocompletion.
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

yellow=$(tput -Txterm setaf 3)
white=$(tput -Txterm setaf 7)

# Use bash completion if it's available
if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion

  # Show current directory, git branch and dirty state in prompt
  GIT_PS1_SHOWDIRTYSTATE=true
  PS1="\W\[$white\]\$(__git_ps1 '(\[\033[1;30m\]%s\[\033[0m\])')$ "
fi

source "`brew --prefix`/etc/grc.bashrc"

source ~/.aliases
source ~/.exports
source ~/.functions
source ~/.hemnet
