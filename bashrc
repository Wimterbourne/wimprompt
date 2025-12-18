# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# When TMUX enable this
#if [ -f ~/scripts/.bash_tpn ]; then
#	. ~/scripts/.bash_tpn
#fi

#ssh() {
#	tmux rename-window "SSH:$*"
#        echo -n "$@: "
#        ap $@
#        echo -e "\n"
#	tmux select-pane -t ${TMUX_PANE} -T "$*"
#	command ssh "$@"
#	tmux rename-window "$(hostname -s)"
#}

ssh() {
    local target=$1

    echo -n "$target: "
    ap "$target"
    echo

    # Maak PS1 veilig als 1 shell-argument (en laat $SUDO_USER intact voor remote-evaluatie)
    local ps1q
    ps1q=$(printf '%q' "$PS1nogit")

    command ssh -t "$target" "bash --noprofile --norc -i -c '
        [ -f /etc/bashrc ] && . /etc/bashrc
        [ -f ~/.bashrc ] && . ~/.bashrc
        export PS1=$ps1q
        exec bash --noprofile --norc -i
    '"
}

rdx() {
 #       tmux rename-window "#[fg=red]RADIX::$*"
#	tmux select-pane -t ${TMUX_PANE} -T "RX:$*"
        command ssh -i ~/.ssh/id_rsa_radix "radix@$@"
#        tmux rename-window "$(hostname -s)"
}

if [ "$EUID" -eq 0 ]
then
  exit
fi

####################
## GIT Formatting ##
#####################
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"
export GIT_PS1_SHOWCOLORHINTS=1

# Prompt with possible GIT implementation
PS1='[\[\e[0;36m\]\A\[\e[0m\]:\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]]-[\[\e[1;34m\]\w\[\e[0m\]]$(__git_ps1 "-[\[\e[0;35m\]%s\[\e[0m\]]")\$ '
PS1nogit='[\[\e[0;36m\]\A\[\e[0m\]:\[\e[0;33m\]${SUDO_USER:+\[\e[9m\]$SUDO_USER\[\e[0m\]/\[\e[1;31m\]}\u\[\e[0m\]@\[\e[0;35m\]\h\[\e[0m\]]-[\[\e[1;34m\]\w\[\e[0m\]]\$ '
# Sudo -i ook met prompt
alias sudo='sudo PS1="$PS1nogit" $@'
alias gris='history|grep $1'
