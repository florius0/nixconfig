__fzf() {
  fzf --reverse --multi "$@"
}

__fd() {
  fd -H --full-path "$1"
}

__preview () {
  echo '
    [ -d {1} ] && exa -lah --color always {1} || \
    ( [ -f {1} ] && [[ "{2}" =~ ^[0-9]+$ ]] && bat --style=numbers --color=always --highlight-line {2} {1} || \
      bat --style=numbers --color=always {1} )
  '
}

fs() {
  local search_dir="${1:-}"
  [ -n "$1" ] && shift

  __fd "$search_dir" | __fzf --ansi \
    --preview "$(__preview {})" \
    --bind 'enter:accept' \
    --print0 $@ | tr -d '\0'
}

fsc() {
  local search_dir="${1:-}"
  [ -n "$1" ] && shift

  __fd "$search_dir" | __fzf --ansi --disabled \
    --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
    --delimiter : \
    --preview "$(__preview {2} {1})" \
    --preview-window '+{2}' \
    --bind 'enter:accept' \
    --print0 $@ | tr -d '\0'
}

fse() {
  local search_dir="${1:-}"
  [ -n "$1" ] && shift

  __fd "$search_dir" | __fzf --ansi \
    --preview "$(__preview {})" \
    --bind 'enter:become($EDITOR {1})' \
    $@
}

fsce() {
  local search_dir="${1:-}"
  [ -n "$1" ] && shift

  __fd "$search_dir" | __fzf --ansi --disabled \
    --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
    --delimiter : \
    --preview "$(__preview {2} {1})" \
    --preview-window '+{2}' \
    --bind 'enter:become($EDITOR +{2}:{3} {1})' $@
}

__fs() {
  local file
  file=$(__fd | __fzf --height 40% --ansi \
    --preview "$(__preview {})" \
    --bind 'enter:accept' \
    --print0 | tr -d '\0')

  [[ -n "$file" ]] && LBUFFER+="$file"
  zle reset-prompt
}

__fsc() {
  local result
  result=$(__fd | __fzf --height 40% --ansi --disabled \
    --bind "change:reload:rg --hidden --column --line-number --no-heading --color=always --smart-case {q} || true" \
    --delimiter : \
    --preview "$(__preview {2} {1})" \
    --preview-window '+{2}' \
    --bind 'enter:accept' --print0 | tr -d '\0' | sed -E 's/^(.+:[0-9]+:[0-9]+):.*$/\1/')

  [[ -n "$result" ]] && LBUFFER+="$result"
  zle reset-prompt
}

# Register functions as ZLE widgets
zle -N __fs
zle -N __fsc

# Bind to keys
bindkey '^F' __fs
bindkey '^T' __fsc
