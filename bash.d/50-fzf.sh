# Load FZF if available
fzf_dirs="
/opt/homebrew/opt/fzf/shell
/opt/local/share/fzf/shell
/usr/local/share/examples/fzf/shell
"
for dir in $fzf_dirs; do
    if [ -d "$dir" ]; then
        for file in $dir/*.bash; do
            . $file
        done
    fi
done
