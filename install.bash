
set -e

APT=$(which apt-get)
PACMAN=$(which pacman)
 if [[ ! -z $APT ]]; then
    apt-get install -y  tmux ninja cmake build-essential zsh
 elif [[ ! -z $PACMAN ]]; then
    apt-get $DEB_PACKAGE_NAME
 else
    echo "error can't install packages"
    exit 1;
 fi
curl https://sh.rustup.rs -sSf | sh -s -- -y
source $HOME/.cargo/env 


tmp=$(mktemp -d)
cd tmp
git clone https://github.com/neovim/neovim
cd nvim
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/usr/local












