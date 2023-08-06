# User specific aliases and functions
alias who='who -H -u -T'
alias c="contents"
# Get Aliases
alias gg='git grep'

if [ "$HOSTOS" == "OpenBSD" ] || [ "$HOSTOS" == "FreeBSD" ]; then
    if [ -x "/usr/local/bin/gls" ]; then
        alias ls='gls --time-style=long-iso -F --color'
    else
        alias ls="ls -FG -D '%F %T'"
    fi
else
    if which exa &> /dev/null; then
        alias ls='exa --time-style=long-iso -F --color=auto --icons'
    else
        alias ls='ls --time-style=long-iso -F --color'
    fi
fi

# jless
jlessBinary="jless.$(uname -s)"
if which "$jlessBinary" &> /dev/null; then
    alias jless="$jlessBinary"
fi

if which bat &> /dev/null; then
    alias cat='bat --paging=never'
fi

if which neomutt &> /dev/null; then
    alias mutt=$(which neomutt)
fi

# MetaCPAN Env
METACPAN="$HOME/code/CPAN/metacpan-developer"
if [ -d "$METACPAN" ]; then
    alias mc="cd $METACPAN;"
else
    alias mc="echo  'No MetaCPAN dev environment found at $METACPAN!' && exit 1"
fi
