rootless_docker_sock="$XDG_RUNTIME_DIR/docker.sock";
if [ -e "$rootless_docker_sock" ]; then
    export DOCKER_HOST="unix://$rootless_docker_sock"
fi
