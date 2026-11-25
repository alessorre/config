# ----------------------------------------
# homebrew
# ----------------------------------------

if [[ $OSTYPE == darwin* && -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi

# ----------------------------------------
# visual studio code
# ----------------------------------------

_code_bin="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
if [[ $OSTYPE == darwin* && -d $_code_bin ]]; then
  path+=($_code_bin)
fi
unset _code_bin