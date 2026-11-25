typeset -U path

if [[ $OSTYPE == darwin* ]]; then
    SHELL_SESSIONS_DISABLE=1
fi

# ----------------------------------------
# telemetry opt-outs
# ----------------------------------------

export DO_NOT_TRACK=1
export DISABLE_TELEMETRY=1
export DISABLE_ERROR_REPORTING=1
export HOMEBREW_NO_ANALYTICS=1
export TURBO_TELEMETRY_DISABLED=1
export NEXT_TELEMETRY_DISABLED=1

# ----------------------------------------
# tools
# ----------------------------------------

# less
export LESSHISTFILE="$XDG_STATE_HOME/lesshst"
# fnm
export FNM_DIR="$XDG_DATA_HOME/fnm"
# pnpm
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
# npm
export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"
export npm_config_cache="$XDG_CACHE_HOME/npm"
# node repl
export NODE_REPL_HISTORY="$XDG_STATE_HOME/node_repl_history"
# rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
# go
export GOPATH="$XDG_DATA_HOME/go"
# python repl
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"
# kubernetes
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
# azure
export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"

# ----------------------------------------
# path, editor
# ----------------------------------------

_user_env() {
  # local editor='nvim'
  # local editor='zed --wait'
  # local editor='zeditor --wait' # arch
  local editor='code --wait'

  path=(
    $HOME/.local/bin
    $PNPM_HOME/bin
    ${CARGO_HOME:+$CARGO_HOME/bin}
    ${GOPATH:+$GOPATH/bin}
    $path
  )

  if (( $+commands[${editor%% *}] )); then
    export EDITOR=$editor
  else
    export EDITOR=vi
  fi
  export VISUAL=$EDITOR
}

_user_env