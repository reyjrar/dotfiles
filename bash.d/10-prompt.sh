# User specific environment and startup programs

function prompt_extra() {
    addition=$1;
    # Color if not colored
    echo $addition | grep '\\' &> /dev/null;
    if [ "$?" != "0" ]; then
        addition="${bldblk}(${host_color}${addition}${bldblk})$txtrst";
    fi;

    if [ -z $PROMPT_EXTRA ]; then
        PROMPT_EXTRA=$addition;
    else
        PROMPT_EXTRA="$PROMPT_EXTRA$addition"
    fi;
}

function before_prompt() {
    # Grab global $?;
    retval=$?

    history -a;     # Record history

    printf "$bldblk[$host_color%s$bldblk] $(get_user_color)%s" "$(date '+%H:%M:%S')" "$PWD"

    if [ -x ~/bin/vcprompt ] && [ "$VCPROMPT" != "disable" ]; then
        vc_out=`~/bin/vcprompt`;
        [ ${#vc_out} -gt 0 ] && printf " $vc_out";
    fi;

    [ ! -z $PROMPT_EXTRA ] && printf " $PROMPT_EXTRA";

    [ $retval -ne 0 ] && printf " $bldred[*${txtred}${retval}${bldred}*]$txtrst";

    printf "\n";
}


VCPROMPT_FORMAT="$bldblk[$txtcyn%n$blkblk:$txtgrn%b$bldblk@$txtred%r$txtpur%m%u$bldblk]";
PROMPT_COMMAND=before_prompt
PS1="\[$(get_user_color)\]\u\[$bldblk\]@\[$host_color\]\h \[$(get_user_color)\]\\\$ \[$txtrst\]"

export PS1 VCPROMPT_FORMAT PROMPT_COMMAND
