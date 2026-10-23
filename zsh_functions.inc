log() {
  echo >&2 "[~/.zshrc] $(tput setaf 245)$*$(tput sgr0)"
}

retry() {
  while true; do $@; sleep 1; done
}

til() {
  while true; do $@; if [ $? -eq 0 ]; then break; fi; sleep 1; done
}

tilfails() {
  while $@; do; sleep 1; done
}

mcd() {
  mkdir -p "${1:?Need to specify an argument}" && cd "$1"
}

goto() {
  cd "$(dirname "$(readlink -f "$(command -v "$@")")")" || false
}

portkill() {
  ps="$(lsof -t -i:"$1")"
  if [[ -z "$ps" ]]; then
    echo "no processes found"
  else
    kill -9 "$ps" && echo "$ps"
  fi
}

measure() {
  local ts=$(date +%s%N)
  $@
  local tt=$((($(date +%s%N) - $ts)/1000000))
  echo "$(tput setaf 245)\"${1}\" took $tt ms.$(tput sgr0)" >&2
}

_git_dbg() {
  echo >&2 "$(tput setaf 1)+ git $@$(tput sgr0)"
  git "$@"
}

_kubectl_dbg() {
  echo >&2 "$(tput setaf 1)+ kubectl $@$(tput sgr0)"
  kubectl "$@"
}

kr() {
    set -x;
    image="$1"
    shift
    kubectl run --rm --restart=Never --image-pull-policy=IfNotPresent -i -t \
    	--image="${image}" tmp-"${RANDOM}" $@
}

demo() {
    PS1=$(tput setaf 2)\$\ $(tput sgr0)
    export PS1
    clear
}

sum() {
   awk '{ sum += $1; } END { print sum; }'
}

isolatectx() {
  tmp="$(mktemp)"
  KUBECONFIG=$HOME/.kube/config kubectl config view --minify --flatten --context="$1" > "$tmp"
  echo "$(tput setab 3; tput setaf 1)Starting new shell only with context \"$1\"...$(tput sgr0)"
  env KUBECONFIG="$tmp" $SHELL
  # the flattened kubeconfig contains credentials, do not leave it behind
  rm -f "$tmp"
}
