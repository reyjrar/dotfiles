# User specific aliases and functions
alias who='who -H -u -T'

# Git Aliases
alias gg='git grep'
if hash git-delta &> /dev/null; then
   : # noop
elif hash difft &> /dev/null; then
    export GIT_EXTERNAL_DIFF="difft --skip-unchanged --display=inline"
fi

## Alias for ls
if hash lsd &> /dev/null; then
    alias ls='lsd --date="+%F %T" -F'
elif hash eza &> /dev/null; then
    alias ls='eza --time-style=long-iso -F --color=auto --icons'
elif hash exa &> /dev/null; then
    alias ls='exa --time-style=long-iso -F --color=auto --icons'
elif hash gls &> /dev/null; then
    alias ls='gls --time-style=long-iso -F --color'
elif [ "$HOSTOS" = "OpenBSD" ] || [ "$HOSTOS" = "FreeBSD" ]; then
    alias ls="ls -FG -D '%F %T'"
else
    alias ls='ls --time-style=long-iso -F --color'
fi

## FZF
if hash fzf &> /dev/null; then
    alias f="fzf --delimiter=':' --preview 'bat --style=numbers --color=always --line-range :500 {1}' --bind 'enter:become(vim {1})'"
fi

## jless
jlessBinary="jless.$(uname -s)"
if hash "$jlessBinary" &> /dev/null; then
    alias jless="$jlessBinary"
fi

## bat
if hash bat &> /dev/null; then
    alias cat='bat --paging=never'
fi

## kubecolor
if hash kubecolor &> /dev/null; then
    alias kubectl=kubecolor
fi

## neomutt
if hash neomutt &> /dev/null; then
    alias mutt=$(which neomutt)
fi
