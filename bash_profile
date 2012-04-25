# Set up the prompt, and export variables

# Colors:
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Set Host Coloration based on OS
case `uname -s` in
    "Darwin"    ) host_color="$txtblu";;
    "Linux"     ) host_color="$txtred";;
    *           ) host_color="$bldpur";;
esac;

# Get the /24 we're connected to
case "$(uname -s)" in
    "Darwin"    ) netstat_opts="-rn -f inet";;
    *           ) netstat_opts="-rn";;
esac

LOCAL_NETWORK=$(netstat $netstat_opts |grep -P '^(0.0.0.0|default)'|awk '{print $2}'| awk -F. '{print $1 "." $2 "." $3}')
export LOCAL_NETWORK;

function get_user_color() {
    # Set User Color based on Name
    case "$USER" in
        "root"      )   user_color="$bldred";;
        "brad"      )   user_color="$txtgrn";;
        "blhotsky"  )   user_color="$txtcyn";;
        *           )   user_color="$txtpur";;
    esac
    echo $user_color;
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

    [ ! -z $PROMPT_EXTRA ] && printf " $bldblk(${host_color}$PROMPT_EXTRA$bldblk)";

    [ $retval -ne 0 ] && printf " $bldred[*${txtred}${retval}${bldred}*]$txtrst";

    printf "\n";
}

if [ "$PS1" ] && [ "$BASHRC" != 1 ]; then
    . ~/.bashrc
fi;

# User specific environment and startup programs
VCPROMPT_FORMAT="$bldblk[$txtcyn%n$blkblk:$txtgrn%b$bldblk@$txtred%r $txtpur%m%u$bldblk]";
PROMPT_COMMAND=before_prompt
PS1="\[$(get_user_color)\]\u\[$bldblk\]@\[$host_color\]\h \[$(get_user_color)\]\\\$ \[$txtrst\]"
USERNAME=""
EDITOR="vim"

export USERNAME EDITOR VCPROMPT_FORMAT PS1 PROMPT_COMMAND
