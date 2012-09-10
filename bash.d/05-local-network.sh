# Get the /24 we're connected to
case "$(uname -s)" in
    "Darwin"    ) netstat_opts="-rn -f inet";;
    *           ) netstat_opts="-rn";;
esac

LOCAL_NETWORK=$(netstat $netstat_opts |grep '^(0.0.0.0|default)'|awk '{print $2}'| awk -F. '{print $1 "." $2 "." $3}')
export LOCAL_NETWORK;
