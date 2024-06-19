# Setup for Kubernetes

# Load completions
for cmd in 'kubectl' 'minikube'; do
    if hash "$cmd" &> /dev/null; then
        source <($cmd completion $(basename "$SHELL"))
    fi
done
