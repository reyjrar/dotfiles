# Fix SSH auth socket location so agent forwarding works with tmux
if ! test -d ~/.ssh; then
    mkdir -m 0700 ~/.ssh
fi
if test "$SSH_AUTH_SOCK" ; then
    ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
