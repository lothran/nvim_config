node_dir="$HOME/.local/node-v20.9.0-linux-x64"
if [ ! -d "$node_dir" ]; then
  wget https://nodejs.org/dist/v20.9.0/node-v20.9.0-linux-x64.tar.xz -O /tmp/node-v20.9.0-linux-x64.tar.xz || print_error "Failed to download node"
  tar -xf /tmp/node-v20.9.0-linux-x64.tar.xz -C /tmp || print_error "Failed to extract node"
  rsync -a /tmp/node-v20.9.0-linux-x64/ "$HOME/.local/" || print_error "Failed to merge node into $HOME/.local"
  rm -rf /tmp/node-v20.9.0-linux-x64* || print_error "Failed to remove extracted node files"
  print_success "node installed and merged"
else
  print_skip "node already exists in $HOME/.local"
fi

