# ~/.bashrc
#
# Bash startup file for interactive non-login shells.


# If not running interactively, don't do anything.
[[ -z "$PS1" ]] && return


# Shell Options
# ----------------------------------------------------------------------------

# Correct minor errors in the spelling of pathnames when using `cd`.
shopt -s cdspell

# Check the window size after a process completes.
shopt -s checkwinsize

# Append to the history file, rather than overwriting it.
shopt -s histappend

# Enable case-insensitive pattern matching when performing filename expansion.
shopt -s nocaseglob


# Shell Environment
# ----------------------------------------------------------------------------

# Make `vi` the default editor.
export EDITOR=vi

# Don't save duplicate entries on the history list.
export HISTCONTROL=ignoredups

# Commands not to be saved on the history list.
export HISTIGNORE="clear:cls:la:ll:ls:ltr:cd:pwd:exit:date"

# Prefer US English locale and UTF-8 encoding.
export LANG=en_US.UTF-8

# Options for `less`:
#     -i: ignore case when searching
#     -F: automatically quit `less` when the file can be displayed on the
#         first screen
#     -R: display ANSI colors
#     -X: don't clear the screen when quitting
export LESS="-iFRX"

# Make `less` the default pager.
export PAGER=less

# Set prompt.
export PS1="\u@\h:\w$ "

# Make `tree` use the same (default) colors as OS X `ls`.
export TREE_COLORS=":no=00:fi=00:di=00;34:ln=00;35:pi=40;33:so=00;32:bd=46;34:cd=43;34:or=40;31;01:ex=00;31:su=00;41:sg=00;46:tw=00;42:ow=00;43:"

# Homebrew package manager.
if [[ -n $(command -v brew) ]]; then
    export HOMEBREW_TEMP=$TMPDIR
    source $(brew --repo)/Library/Contributions/brew_bash_completion.sh

    # Ruby version management: rbenv and ruby-build.
    if [[ -n $(command -v rbenv) ]]; then
        export RBENV_ROOT=$(brew --repo)/lib/rbenv
        export RUBY_CONFIGURE_OPTS="--disable-install-doc"
        eval "$(rbenv init -)"
    fi
fi

# Append PostgreSQL to PATH.
[[ -d /usr/local/pgsql/bin ]] && export PATH=$PATH:/usr/local/pgsql/bin

# Append Hadoop to PATH.
[[ -d /usr/local/hadoop/bin ]] && export PATH=$PATH:/usr/local/hadoop/bin

# Append MySQL to PATH.
[[ -d /usr/local/mysql/bin ]] && export PATH=$PATH:/usr/local/mysql/bin

# Oracle Instant Client.
if [[ -d /usr/local/oracle/bin ]]; then
    export NLS_LANG=AMERICAN_AMERICA.UTF8
    export PATH=$PATH:/usr/local/oracle/bin
    export SQLPATH=$HOME/local/sqlplus
    export TNS_ADMIN=/usr/local/oracle/admin/network
fi

# Append ~/local/bin to PATH.
[[ -d $HOME/local/bin ]] && export PATH=$PATH:$HOME/local/bin


# Functions
# ----------------------------------------------------------------------------

# Recursively delete files that match a certain pattern from the current
# directory (by default all .DS_Store files are deleted).
deletefiles() {
    local q="${1:-*.DS_Store}"

    find . -type f -name "$q" -ls -delete
} 

# Remove downloaded file(s) from the OS X quarantine.
unquarantine() {
    local attribute

    for attribute in com.apple.metadata:kMDItemDownloadedDate com.apple.metadata:kMDItemWhereFroms com.apple.quarantine; do
        xattr -rd "$attribute" "$@"
    done
}


# Bash aliases.
[[ -r ~/.bash_aliases ]] && source ~/.bash_aliases

# Run a local bashrc file if it exists.
[[ -r ~/.bashrc.local ]] && source ~/.bashrc.local
