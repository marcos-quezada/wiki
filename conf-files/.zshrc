# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

# Environment variables
export ORIENTDB_HOME=$HOME/Development/orientdb-community-2.2.33/

# Theme
ZSH_THEME="spaceship"

# Aliases
alias zshconfig="vim ~/.zshrc"
alias ohmyzsh="vim ~/.oh-my-zsh"
alias vimnotes="vim -f --servername Notes -u ~/.vim/notes.vim"

# Waiting Dots
COMPLETION_WAITING_DOTS="true"

# Plugins
plugins=(git)

# You can customize where you put it but it's generally recommended that you put in $HOME/.zplug
if [[ ! -d ~/.zplug ]];then
    git clone https://github.com/b4b4r07/zplug ~/.zplug
fi

# Async for zsh, used by pure
zplug "mafredri/zsh-async", from:github, defer:0
# Load completion library for those sweet [tab] squares
zplug "lib/completion", from:oh-my-zsh
# Syntax highlighting for commands, load last
zplug "zsh-users/zsh-syntax-highlighting", from:github, defer:3
# Theme!
zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

zplug load

# Actually install plugins, prompt user input
if ! zplug check --verbose; then
    printf "Install zplug plugins? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
