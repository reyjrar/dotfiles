# Fix SSH auth socket location so agent forwarding works with tmux
if ! test -d ~/.ssh; then
    mkdir -m 0700 ~/.ssh
fi
if test "$SSH_AUTH_SOCK" ; then
    if [ -L "$SSH_AUTH_SOCK" ]; then
        sock_path=$(ls -l ~/.ssh/ssh_auth_sock |awk '{print $NF}'| head -1);
    fi
    if [ -z "$sock_path" ] || [ basename "$sock_path" != "ssh_auth_sock" ]; then
        ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
    fi
fi
