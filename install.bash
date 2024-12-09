#!/bin/bash

#lsps
curl https://sh.rustup.rs -sSf | sh
export PATH="~/.cargo/bin:${PATH}"
cargo install neocmakelsp
sudo apt-get wget install ninja-build gettext cmake unzip curl build-essential
sudo apt-get install clangd
pip install pyright

#neovim

tmp=$(mktemp -d)
cd tmp
git clone https://github.com/neovim/neovim
cd nvim
make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install

#font
tdir=$(mktemp)
cd $tdir
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/0xProto.tar.xz
tar -zxvf 0xProto.tar.xz
sudo cp *.ttf /usr/local/share/fonts
#kitty

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# Place the kitty.desktop file somewhere it can be found by the OS
cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/
# If you want to open text files and images in kitty via your file manager also add the kitty-open.desktop file
cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/
# Update the paths to the kitty and its icon in the kitty desktop file(s)
sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop
sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop
# Make xdg-terminal-exec (and hence desktop environments that support it use kitty)
echo 'kitty.desktop' > ~/.config/xdg-terminals.list

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"











