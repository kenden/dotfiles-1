#!/usr/bin/env bash
# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{bash_prompt,exports,aliases,functions,extra}; do
    # shellcheck source=/dev/null
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

ulimit -n 10000

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

if [[ $(which brew) ]]; then
  if [ -f "$(brew --prefix git)/etc/bash_completion.d/git-completion.bash" ]; then
    # shellcheck source=/dev/null
    source "$(brew --prefix git)/etc/bash_completion.d/git-completion.bash"
  elif [ -f ~/.git-completion.bash ]; then
    source ~/.git-completion.bash
  fi
elif [ -f ~/.git-completion.bash ]; then
  source ~/.git-completion.bash
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
# shellcheck source=/dev/null
[[ -f $NVM_DIR/nvm.sh ]] && source $NVM_DIR/nvm.sh
# shellcheck source=/dev/null
[[ -f $NVM_DIR/bash_completion ]] && source $NVM_DIR/bash_completion

# PYTHON virtualenv specifics
export WORKON_HOME="$HOME/.pyenvs"
