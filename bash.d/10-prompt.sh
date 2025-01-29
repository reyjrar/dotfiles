# Starship precmd to set SYSTEM_APPEARANCE
export starship_precmd_user_func="set_system_appearance"

# User specific environment and startup programs
function prompt_extra() {
    addition=$1;
    # Color if not colored
    echo $addition | grep '\\' &> /dev/null;
    if [ "$?" != "0" ]; then
        addition="${bldblk}(${host_color}${addition}${bldblk})$txtrst";
    fi;

    if [ -z "${PROMPT_EXTRA+x}" ]; then
        PROMPT_EXTRA=$addition;
    else
        PROMPT_EXTRA="$PROMPT_EXTRA$addition"
    fi;
}

function before_prompt() {
    # Grab global $?;
    retval=$?

    history -a;     # Record history
    history -n;     # Reread history
    _set_win_title $(hostname -s)

    # Enable tmux-powerline cwd things
    [ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD"

    printf "$bldblk[$host_color%s$bldblk] $(get_user_color)%s" "$(date '+%H:%M:%S')" "$PWD"

    if [ "${VCPROMPT+x}" != "disable" ]; then
        if git status &> /dev/null; then
            rev=$(git rev-parse --short HEAD)
            branch=$(git branch 2> /dev/null | grep '^*' | colrm 1 2)
            flags=""
            if ! git diff --no-ext-diff --exit-code --quiet; then
                flags+="+"
            fi
            if ! git diff --no-ext-diff --exit-code --cached --quiet; then
                flags+="*"
            fi
            if git ls-files --others --exclude-standard --directory --no-empty-directory --error-unmatch -- ':/*' &> /dev/null; then
                flags+="?"
            fi
            if git rev-parse --verify --quiet refs/stash &>/dev/null; then
                flags+="$"
            fi
            printf " ${bldblk}[${txtcyn}git${bldblk}:${txtgrn}%s${bldblk}@${txtred}%s${txtpur}%s${bldblk}]" "$branch" "$rev" "$flags"
        fi
    fi

    [ ! -z "${PROMPT_EXTRA+x}" ] && printf " $PROMPT_EXTRA";

    [ $retval -ne 0 ] && printf " $bldred[*${txtred}${retval}${bldred}*]$txtrst";

    printf "\n";
}

# Configure VCPROMPT if using
if [ -x ~/bin/vcprompt ]; then
    export VCPROMPT_FORMAT="$bldblk[$txtcyn%n$blkblk:$txtgrn%b$bldblk@$txtred%r$txtpur%m%u$bldblk]";
fi

export PROMPT_COMMAND=before_prompt
export PS1="\[$(get_user_color)\]\u\[$bldblk\]@\[$host_color\]\h \[$(get_user_color)\]\\\$ \[$txtrst\]"
