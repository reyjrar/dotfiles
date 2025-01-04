# Path to your Oh My Zsh installation.
ZSH="$HOME/.oh-my-zsh"
if [ -d "$ZSH" ]; then
    export ZSH;

    # OMZ Themes - https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="re5et"

    # OMZ Settings
    HIST_STAMPS="yyyy/mm/dd"
    ZOXIDE_CMD_OVERRIDE="cd"
    ZSH_TMUX_AUTOCONNECT=false
    DISABLE_LS_COLORS=true
    export STARSHIP_CONFIG="$HOME/.starship/config.toml"

    # Plugins
    plugins=(aliases asdf aws battery brew colored-man-pages colorize docker docker-compose emoji-clock fzf gh git git-prompt gitignore gnu-utils golang istioctl iterm2 kubectl macos minikube perl podman postgres ssh starship themes tmux zoxide)

    set +u
    source $ZSH/oh-my-zsh.sh

    # User configuration
    export ZSH_COLORIZE_STYLE="monokai"
    export ZSH_COLORIZE_CHROMA_FORMATTER=terminal256
fi
