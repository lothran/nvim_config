#!/bin/bash
curl https://sh.rustup.rs -sSf | sh
export PATH="~/.cargo/bin:${PATH}"
cargo install neocmakelsp


sudo apt-get wget install ninja-build gettext cmake unzip curl build-essential
tmp=$(mktemp -d)
cd tmp
git clone https://github.com/neovim/neovim
cd nvim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
sudo apt-get install clangd

tdir=$(mktemp)
cd $tdir
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.tar.xz
tar -zxvf 0xProto.tar.xz
sudo cp *.ttf /usr/local/share/fonts












