# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+:}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1048576
HISTFILESIZE=1048576
set histappend=true
LAST_HISTORY_WRITE=$SECONDS
   function prompt_command {
       if [ $(($SECONDS - $LAST_HISTORY_WRITE)) -gt 300 ]; then
           history -a
           LAST_HISTORY_WRITE=$SECONDS
       fi
	}
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -l'
alias la='ls -A'
alias l='ls -CF'


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

if [ -d ${HOME}/bin ]; 
then PATH=${HOME}/bin:${PATH} ; 
fi

if [ -d ${HOME}/lib ]; then
   if [ -n "${LD_LIBRARY_PATH}" ]; then
     export LD_LIBRARY_PATH=${HOME}/lib:${LD_LIBRARY_PATH}
   else
     export LD_LIBRARY_PATH=${HOME}/lib
   fi
fi

if [ -f $HOME/etc/config.site ]; then
	export CONFIG_SITE=$HOME/etc/config.site
fi

if [ -d ${HOME}/lib/pkgconfig ]; then
	export PKG_CONFIG_PATH=${HOME}/lib/pkgconfig
fi

if [ -e $HOME/bin/dssp ]; then
	export DSSP=$HOME/bin/dssp
fi

source /usr/local/gromacs/bin/GMXRC

export DEBEMAIL="lina.oahz@gmail.com"
export DEBFULLNAME="Lina Zhao"
alias dquilt="quilt --quiltrc=${HOME}/.quiltrc-dpkg"

export AMBERHOME=/home/lina/src/amber10
export PATH="/home/lina/src/amber10/exe:$PATH"
#setxkbmap -option grp:switch,grp:alt_shift_toggle,grp_led:scroll us


export PERL_LOCAL_LIB_ROOT="/home/lina/perl5";
export PERL_MB_OPT="--install_base /home/lina/perl5";
export PERL_MM_OPT="INSTALL_BASE=/home/lina/perl5";
export PERL5LIB="/home/lina/perl5/lib/perl5/x86_64-linux-gnu-thread-multi:/home/lina/perl5/lib/perl5:/home/lina/lib/perl5";
export PATH="/home/lina/perl5/bin:$PATH";

