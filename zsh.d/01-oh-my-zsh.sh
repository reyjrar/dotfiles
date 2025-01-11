# Path to your Oh My Zsh installation.
OMZ=("$HOME/.oh-my-zsh" "/usr/local/share/ohmyzsh")

for dir in $OMZ; do
    if [ ! -d "$dir" ]; then
        continue;
    fi

    # OMZ Dir
    export ZSH="$dir"

    # OMZ Themes - https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="re5et"

    # OMZ Settings
    HIST_STAMPS="yyyy/mm/dd"
    ZOXIDE_CMD_OVERRIDE="cd"
    ZSH_TMUX_AUTOCONNECT=false
    DISABLE_LS_COLORS=true
    DISABLE_UNTRACKED_FILES_DIRTY=true

    # User configuration
    export ZSH_COLORIZE_STYLE="monokai"
    export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256

    # Plugins
    plugins=(aliases asdf aws battery brew colored-man-pages colorize docker docker-compose emoji-clock fzf gh git git-prompt gitignore gnu-utils golang istioctl iterm2 kubectl macos minikube perl podman postgres ssh starship themes tmux zoxide)
    set +u
    source $ZSH/oh-my-zsh.sh

    # Settings:
    zstyle ':omz:update' mode disabled
    break
done
