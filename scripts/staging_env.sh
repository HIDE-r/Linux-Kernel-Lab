#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  source scripts/staging_env.sh
  source scripts/staging_env.sh --off
  scripts/staging_env.sh --print
  scripts/staging_env.sh --run <cmd> [args...]

Description:
  Prefer host tools from output/staging_dir/host in PATH.
EOF
}

is_sourced() {
  [[ "${BASH_SOURCE[0]}" != "$0" ]]
}

prepend_unique() {
  local var_name="$1"
  local value="$2"
  local cur
  cur="${!var_name-}"
  [[ -d "$value" ]] || return 0
  case ":$cur:" in
    *":$value:"*) ;;
    *)
      if [[ -n "$cur" ]]; then
        printf -v "$var_name" '%s:%s' "$value" "$cur"
      else
        printf -v "$var_name" '%s' "$value"
      fi
      export "$var_name"
      ;;
  esac
}

remove_from_path() {
  local target="$1"
  local cur new entry
  cur="${PATH-}"
  new=""
  IFS=':' read -r -a __path_entries <<< "$cur"
  for entry in "${__path_entries[@]}"; do
    [[ -z "$entry" ]] && continue
    [[ "$entry" == "$target" ]] && continue
    if [[ -n "$new" ]]; then
      new="${new}:$entry"
    else
      new="$entry"
    fi
  done
  PATH="$new"
  export PATH
}

enable_env() {
  if [[ -z "${STAGING_ENV_OLD_PATH+x}" ]]; then
    export STAGING_ENV_OLD_PATH="${PATH-}"
  fi
  prepend_unique PATH "${STAGING_DIR_HOST}/bin"
  prepend_unique PATH "${STAGING_DIR_HOST}/sbin"
}

disable_env() {
  if [[ -n "${STAGING_ENV_OLD_PATH+x}" ]]; then
    PATH="${STAGING_ENV_OLD_PATH}"
    export PATH
    unset STAGING_ENV_OLD_PATH
    return
  fi
  remove_from_path "${STAGING_DIR_HOST}/bin"
  remove_from_path "${STAGING_DIR_HOST}/sbin"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOPDIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
STAGING_DIR="${STAGING_DIR:-${TOPDIR}/output/staging_dir}"
STAGING_DIR_HOST="${STAGING_DIR}/host"
export STAGING_DIR STAGING_DIR_HOST

mode="enable"
if [[ "${1-}" == "--help" || "${1-}" == "-h" ]]; then
  usage
  exit 0
elif [[ "${1-}" == "--print" ]]; then
  mode="print"
elif [[ "${1-}" == "--off" ]]; then
  mode="off"
elif [[ "${1-}" == "--run" ]]; then
  mode="run"
  shift
  if [[ "$#" -eq 0 ]]; then
    echo "error: --run requires a command" >&2
    usage >&2
    exit 2
  fi
fi

if [[ "$mode" == "run" ]]; then
  enable_env
  exec "$@"
fi

if [[ "$mode" == "off" ]]; then
  disable_env
elif [[ "$mode" == "enable" || "$mode" == "print" ]]; then
  enable_env
else
  echo "error: unsupported mode: $mode" >&2
  exit 2
fi

if [[ "$mode" == "print" ]]; then
  cat <<EOF
export STAGING_DIR='${STAGING_DIR}'
export STAGING_DIR_HOST='${STAGING_DIR_HOST}'
export STAGING_ENV_OLD_PATH='${STAGING_ENV_OLD_PATH-}'
export PATH='${PATH}'
EOF
  exit 0
fi

if ! is_sourced; then
  if [[ "$mode" == "off" ]]; then
    cat <<EOF
Environment restored in subprocess.
To restore in current shell, run:
  source scripts/staging_env.sh --off
EOF
  else
    cat <<EOF
Environment prepared in subprocess.
To apply in current shell, run:
  source scripts/staging_env.sh
EOF
  fi
fi
