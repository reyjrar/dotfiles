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


    # zsh extensions
    zexts+=(
        "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
        "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
    )
fi
for ext in $zexts; do
    [ -f "$ext" ] && . "$ext"
done
