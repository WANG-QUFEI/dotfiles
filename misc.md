## Misellaneous Useful Commands & Scripts

### fish
```fish
function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end

source /opt/local/share/fzf/shell/key-bindings.fish

fish_user_key_bindings

wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/
fish_ssh_agent

abbr --add gco git checkout
abbr --add gcm git commit
abbr --add gsa git status
abbr --add gsa ghy history
abbr --add glp git log -p
abbr --add glt git log --pretty=format:"%h %an %ad: %s" --graph
abbr --add gst git status
abbr --add dcu 'docker compose up -d'
abbr --add dcd 'docker compose down --remove-orphans'
abbr --add drm 'docker ps --filter label=com.docker.compose.project -aq | xargs docker rm --volumes -f'
abbr --add zpgproxy 'PGPROXY_PORT=9987 arthur db pgproxy'
abbr --add ptins sudo port install
abbr --add ptsch port search --name
abbr --add ptclm sudo port claim
```

### zsh
```zsh
path=("/opt/homebrew/bin" $path)
path=("$HOME/go/bin" $path)
export PATH

alias dcu='docker compose up -d'
alias dcd='docker compose down --remove-orphans'
alias drm='docker ps --filter label=com.docker.compose.project -aq | xargs docker rm --volumes -f'
alias git_log_patch='git log -p'
alias git_log_pretty='git log --pretty=format:"%h %an %ad: %s" --graph'
alias zpgproxy='PGPROXY_PORT=9987 arthur db pgproxy'

# MacOS related
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1
defaults write com.apple.dock ResetLaunchPad -bool true; killall Doc
```

### go
```zsh
go env -w GOPRIVATE='github.com/Zimpler/*,gitlab.zimpler.com/*,gitlab.tooling.zimpler.net/*'
```
