alias shopify-dev='/Users/carmelaleung/src/github.com/Shopify/shopify-app-cli/bin/shopify'
alias theme='/Users/carmelaleung/.cache/shopify/themekit'

alias githist="git log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short"

alias ls='ls -G'
alias la='ls -aG'
alias lss='git branch; ls -G'
alias laa='git branch; ls -aG'


## USE SPIN DEFAULT PROMPT UNTIL I FIGURE OUT HOW TO MAKE MY OWN

# Prompt

# Keep it simple when Emacs is connecting

if [[ "$TERM" == "dumb" ]]
then
  unsetopt zle
  unsetopt prompt_cr
  unsetopt prompt_subst
  if whence -w precmd >/dev/null; then
      unfunction precmd
  fi
  if whence -w preexec >/dev/null; then
      unfunction preexec
  fi
  PS1='$ '
  return
fi

# Interactive prompt

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst

zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr '*'
zstyle ':vcs_info:*' stagedstr '+'
zstyle ':vcs_info:git:*' formats '%F{200}[%b%u%c]%f'
zstyle ':vcs_info:*' enable git

PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%~%b $vcs_info_msg_0_ $ '
