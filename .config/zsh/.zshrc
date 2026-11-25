# ----------------------------------------
# path order
# ----------------------------------------

if [[ $OSTYPE == darwin* ]]; then
  _user_env
fi

# ----------------------------------------
# ensure XDG and tool directories exist
# ----------------------------------------

() {
  local d
  local -a dirs=(
    # XDG base directories
    $XDG_CONFIG_HOME
    $XDG_CACHE_HOME
    $XDG_DATA_HOME
    $XDG_STATE_HOME
    $HOME/.local/bin
    $XDG_STATE_HOME/zsh
    $XDG_CACHE_HOME/zsh
    $XDG_CACHE_HOME/zsh/zcompcache
    $XDG_CACHE_HOME/zsh/completions
    $FNM_DIR
    $PNPM_HOME/bin
    $XDG_CONFIG_HOME/npm
  )
  local -a missing
  for d in $dirs; do
    [[ -d $d ]] || missing+=($d)
  done
  if (( $#missing )); then
    mkdir -p -- $missing
  fi
}

# ----------------------------------------
# history
# ----------------------------------------

HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=10000
SAVEHIST=10000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

setopt AUTO_CD
setopt INTERACTIVE_COMMENTS
setopt NO_BEEP
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt NUMERIC_GLOB_SORT
setopt PROMPT_SUBST

unsetopt PROMPT_SP

# ----------------------------------------
# keybindings
# ----------------------------------------

# bindkey -v
bindkey -e

# ----------------------------------------
# ghostty shell integration (also after `exec zsh`, tmux, subshells)
# ----------------------------------------

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"
fi

# ----------------------------------------
# completion
# ----------------------------------------

typeset -U fpath

fpath=(${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh/site-functions} $fpath)

() {
  local dir=$XDG_CACHE_HOME/zsh/completions
  local -A generators=(
    fnm  'completions --shell zsh'
    pnpm 'completion zsh'
  )
  local tool bin out
  local -a old
  for tool in ${(k)generators}; do
    bin=$commands[$tool]
    [[ -n $bin ]] || continue
    old=( $dir/_$tool(N.mw+1) )
    if [[ ! -s $dir/_$tool || -n $old ]]; then
      if out=$($bin ${=generators[$tool]} 2>/dev/null) && [[ -n $out ]]; then
        print -r -- $out >| $dir/_$tool
      fi
    fi
  done
}
fpath=($XDG_CACHE_HOME/zsh/completions $fpath)

zmodload zsh/complist
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump"

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-rows-first true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:options' description yes
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"

zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{3}%B%d%b%f'
zstyle ':completion:*:messages' format '%F{4}%B%d%b%f'
zstyle ':completion:*:warnings' format '%F{1}%BNo matches: %d%b%f'
zstyle ':completion:*:*:-command-:*:*' group-order aliases builtins functions commands

bindkey -M menuselect '^[[Z' reverse-menu-complete

# ----------------------------------------
# prompt
# ----------------------------------------

autoload -Uz vcs_info
autoload -Uz add-zsh-hook

BRANCH_ICON='' # $'\ue725'
PROMPT_ICON='▶' # $'\u25b6'

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr ' %F{1}[*]%f'
zstyle ':vcs_info:git:*' stagedstr ' %F{2}[+]%f'
zstyle ':vcs_info:git:*' formats " %F{4}${BRANCH_ICON} %b%f%u%c"
zstyle ':vcs_info:git:*' actionformats " %F{4}${BRANCH_ICON} %b | %a%f%u%c"

add-zsh-hook precmd vcs_info
unset BRANCH_ICON

PROMPT='%F{3}%n@%m%f %F{6}%~%f${vcs_info_msg_0_} %(?.%F{2}.%F{1})$PROMPT_ICON%f '

_prompt_newline() {
  [[ -n $_prompt_started ]] && print
  _prompt_started=1
}
add-zsh-hook precmd _prompt_newline

# ----------------------------------------
# fnm
# ----------------------------------------

if (( $+commands[fnm] )); then
  eval "$(fnm env --use-on-cd --shell zsh)"
fi

# ----------------------------------------
# fzf
# ----------------------------------------

if (( $+commands[fzf] )); then
  export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border'
  export FZF_CTRL_T_OPTS='--walker-skip .git,node_modules,target'
  export FZF_ALT_C_OPTS='--walker-skip .git,node_modules,target'
  (( $+commands[bat] )) && FZF_CTRL_T_OPTS+=" --preview 'bat -n --color=always {}'"
  (( $+commands[eza] )) && FZF_ALT_C_OPTS+=" --preview 'eza --tree --level=2 --color=always {}'"
  source <(fzf --zsh)
fi

# ----------------------------------------
# aliases
# ----------------------------------------

alias reload='exec zsh -l'
alias clear='_prompt_started=; printf "\033[H\033[2J\033[3J"'

# ----------------------------------------
# eza
# ----------------------------------------

if (( $+commands[eza] )); then
  ls() {
    local -a opts=(
      --long
      --all
      --group-directories-first
      --icons=auto
      --hyperlink=auto
      --classify=auto
      --header
      --git
      --git-repos
    )
    eza $opts "$@"
  }
elif [[ $OSTYPE == darwin* ]]; then
  ls() { command ls -G "$@" }
elif [[ $OSTYPE == linux* ]]; then
  ls() { command ls --color=auto "$@" }
fi

_ls_on_cd() { ls }
add-zsh-hook chpwd _ls_on_cd

# ----------------------------------------
# git
# ----------------------------------------

git() {
  if [[ $1 == log && $# -eq 1 ]]; then
    command git log --graph --oneline --decorate --all
  else
    command git "$@"
  fi
}

# ----------------------------------------
# plugins
# ----------------------------------------

typeset -a _zsh_syntax_highlighting_paths=(
  ${HOMEBREW_PREFIX:+$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh}
  /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
)
for _zsh_syntax_highlighting_path in $_zsh_syntax_highlighting_paths; do
  if [[ -r $_zsh_syntax_highlighting_path ]]; then
    source $_zsh_syntax_highlighting_path
    break
  fi
done
unset _zsh_syntax_highlighting_path _zsh_syntax_highlighting_paths