# User specific aliases and functions
alias who='who -H -u -T'
alias c="contents"
# Get Aliases
alias gg='git grep'

## Alias for ls
if which lsd &> /dev/null; then
    alias ls='lsd --date="+%F %T" -F'
elif which eza &> /dev/null; then
    alias ls='eza --time-style=long-iso -F --color=auto --icons'
elif which exa &> /dev/null; then
    alias ls='exa --time-style=long-iso -F --color=auto --icons'
elif which gls &> /dev/null; then
    alias ls='gls --time-style=long-iso -F --color'
elif [ "$HOSTOS" == "OpenBSD" ] || [ "$HOSTOS" == "FreeBSD" ]; then
    alias ls="ls -FG -D '%F %T'"
else
    alias ls='ls --time-style=long-iso -F --color'
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
