export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

ZSH=$HOME/.oh-my-zsh

# You can change the theme with another one:
#   https://github.com/robbyrussell/oh-my-zsh/wiki/themes
ZSH_THEME="robbyrussell"

# Useful oh-my-zsh plugins for Le Wagon bootcamps
plugins=(git gitfast git-auto-fetch last-working-dir common-aliases sublime zsh-syntax-highlighting history-substring-search)

# Prevent Homebrew from reporting - https://github.com/Homebrew/brew/blob/master/share/doc/homebrew/Analytics.md
export HOMEBREW_NO_ANALYTICS=1

# Actually load Oh-My-Zsh
source "${ZSH}/oh-my-zsh.sh"
unalias rm # No interactive rm by default (brought by plugins/common-aliases)

# Load rbenv if installed (To manage your Ruby versions)
export PATH="${HOME}/.rbenv/bin:${PATH}"
type -a rbenv > /dev/null && eval "$(rbenv init -)"

# Anaconda binaries (python, pip, conda, jupyter, pytest, pylint etc.)
export PATH="/anaconda3/bin:${HOME}/anaconda3/bin:${PATH}"

# Rails and Ruby uses the local `bin` folder to store binstubs.
# So instead of running `bin/rails` like the doc says, just run `rails`
# Same for `./node_modules/.bin` and nodejs
export PATH="./bin:./node_modules/.bin:${PATH}:/usr/local/sbin"

# Store your own aliases in the ~/.aliases file and load the here.
[[ -f "$HOME/.aliases" ]] && source "$HOME/.aliases"

# Encoding stuff for the terminal
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export GITHUB_NPM_TOKEN=$(cat ~/.npmrc | sed 's/.*authToken=\(.*\)/\1/')


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
eval "$(rbenv init -)"
export PATH=/Users/jeanbaptistecamaret/bin:$PATH


autoload -U add-zsh-hook
load-nvmrc() {
  if [[ -f .nvmrc && -r .nvmrc ]]; then
    nvm use
  elif [[ $(nvm version) != $(nvm version default)  ]]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc


up() {
  if [ -f "bin/update" ]; then
    bin/update
  else
    if [[ $(git branch | grep develop) ]]; then
      BRANCH='develop'
    elif [[ $(git branch | grep main) ]]; then
      BRANCH='main'
    else
      BRANCH='master'
    fi;
    git checkout $BRANCH && git pull
    if [ -f "yarn.lock" ]; then
      yarn
    fi;
  fi;
}
