# Load ZSH Extensions
zexts=()
if hash brew &> /dev/null; then
    # zsh-completion
    zcmplt="$(brew --prefix)/share/zsh-completions"
    if [ -d "$zcmplt" ]; then
        FPATH="$zcmplt:$FPATH"
        autoload -Uz compinit
        compinit
    fi

    # zsh extensions from brew
    zexts+=(
        "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    )
elif hash dnf &> /dev/null; then
    # zsh extensions from RPMs
    zexts+=(
        "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
        "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
    )
fi

# Load Extensions
for ext in $zexts; do
    [ -f "$ext" ] && . "$ext"
done
