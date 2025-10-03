#!/bin/zsh

# Define a function which rename a `target` file to `target.backup` if the file
# exists and if it's a 'real' file, ie not a symlink
backup() {
  target=$1
  # If there's a symlink at target, remove it. If there's a real file/dir, move it to target.backup
  if [ -L "$target" ]; then
    rm "$target"
    echo "-----> Removed existing symlink $target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.backup"
    echo "-----> Moved your old $target config file to $target.backup"
  fi
}

symlink() {
  file=$1
  link=$2
  # Ensure parent dir exists for the link
  parent_dir=$(dirname "$link")
  if [ ! -d "$parent_dir" ]; then
    mkdir -p "$parent_dir"
  fi
  # If a symlink already exists, remove it. If a real file exists, back it up.
  if [ -L "$link" ]; then
    rm "$link"
    echo "-----> Removed existing symlink $link"
  elif [ -e "$link" ]; then
    backup "$link"
  fi
  ln -s "$file" "$link"
  echo "-----> Symlinked $link -> $file"
}

# For all files `$name` in the present folder except `*.sh`, `README.md`, `settings.json`,
# and `config`, backup the target file located at `~/.$name` and symlink `$name` to `~/.$name`
for name in aliases gitconfig irbrc rspec zprofile zshrc; do
  if [ ! -d "$name" ]; then
    target="$HOME/.$name"
    backup $target
    symlink $PWD/$name $target
  fi
done

# Install zsh-syntax-highlighting plugin
CURRENT_DIR=`pwd`
ZSH_PLUGINS_DIR="$HOME/.oh-my-zsh/custom/plugins"
mkdir -p "$ZSH_PLUGINS_DIR" && cd "$ZSH_PLUGINS_DIR"
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "-----> Installing zsh plugin 'zsh-syntax-highlighting'..."
  git clone https://github.com/zsh-users/zsh-autosuggestions
  git clone https://github.com/zsh-users/zsh-syntax-highlighting
fi
cd "$CURRENT_DIR"

# vscode as default git editor
git config --global core.editor "code --wait"

# Symlink SSH config file to the present `config` file for macOS and add SSH passphrase to the keychain
if [[ `uname` =~ "Darwin" ]]; then
  target=~/.ssh/config
  backup $target
  symlink $PWD/config $target
  ssh-add -K ~/.ssh/id_ed25519
fi

# Refresh the current terminal with the newly installed configuration
exec zsh

echo "👌 Carry on with git setup!"
