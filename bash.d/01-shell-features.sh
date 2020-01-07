# Enable / Disable Shell features
shopt -s autocd cdspell dirspell dotglob nocaseglob

if [ -e /opt/local/share/fzf/shell/key-bindings.bash ]; then
    . /opt/local/share/fzf/shell/key-bindings.bash
fi
