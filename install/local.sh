#!/usr/bin/env bash

function rel2abs() {
    local relative=$1
    local cwd=$(pwd);

    cd $relative;
    absolute=$(pwd);
    cd $cwd;

    echo $absolute;
}

function install_rc() {
    rc=$1
    final="$HOME/.$rc";
    whereilive="$basedir/$rc";
    echo -n "setting up $final .. ";
    if [ -f $final ] || [ -L $final ]; then
        echo -n "removing current file .. ";
        rm -f $final;
    elif [ -d $final ]; then
        echo -n "backing up $final .. ";
        tar -zcf "$final.tar.gz" $final;
        rc=$?;
        if [ $rc -ne 0 ]; then
            echo "FAILED TO BACKUP $final, please fix";
            exit 1;
        fi
        echo "";
        echo "!! PLEASE REMOVE $final IF YOU WANT TO INSTALL ME !!"
        echo "";
        return 0;
    fi;
    echo -n "linking to $whereilive .. ";
    ln -s $whereilive $final;
    echo "done.";

}

function install_link() {
    src=$1
    dst=$2

    echo -n "linking '$src' .. ";
    if [ -L "$dst" ]; then
        echo -n "removing existing link .. "
        rm "$dst";
    elif [ -e "$dst" ]; then
        echo "$dst exists";
        return 0;
    fi
    if [ ! -x "$src" ]; then
        echo "not executable, skipping!";
        return 0;
    fi

    ln -s "$src" "$dst";
    echo "linked to $dst";
}

function setup_vim() {
    vundle_repo="https://github.com/VundleVim/Vundle.vim.git"
    vundle_dir="$HOME/.vim/bundle/Vundle.vim"

    echo -n "setting up Vundle .. ";
    if [[ ! -d "$vundle_dir" ]]; then
        echo "not found, installing"
        git clone "$vundle_repo" "$vundle_dir"
        vim +PluginInstall +qall
        echo ""
        echo "setup vim+Vundle."
    else
        echo "already installed."
    fi
    mkdir -p ~/.vimswap
    mkdir -p ~/.vimundo
}

bindir=$(dirname "$0");
basedir=$(rel2abs "${bindir/install}");

for rc in `ls -1 $basedir`; do
    if [ -f $rc ] && [ "$rc" != "README" ]; then
        install_rc $rc;
    elif [ -d $rc ]; then
        if [ ${rc:(-2)} == ".d" ]; then
            install_rc $rc;
        elif [ "$rc" == "starship" ]; then
            install_rc $rc;
        fi
    fi;
done;

# Setup vim
setup_vim;

# Create HOME/bin
[ ! -d "$HOME/bin" ] && mkdir 0750 "$HOME/bin";

# If a git directory, we install controller scripts
if git rev-parse --is-inside-work-tree &> /dev/null; then
    if [ "$EUID" -ne 0 ] && [ -z "$SSH_CONNECTION" ]; then
        for script in $basedir/controller/*; do
            if [ -x "$script" ]; then
                install_link "$script" "$HOME/bin/$(basename "$script")"
            fi
        done
    fi
fi

# Install Utilities
for script in $basedir/bin/*; do
    if [ -x "$script" ]; then
        install_link "$script" "$HOME/bin/$(basename "$script")"
    fi
done

