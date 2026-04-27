#!/bin/bash
set -euo pipefail

extensions_file="${1:-}"
if [[ -z "$extensions_file" ]]; then
  echo "usage: vscode_snapshot_install_extensions.sh <path-to-vscode_extensions.txt>" >&2
  exit 1
fi
if [[ ! -f "$extensions_file" ]]; then
  echo "error: extensions file not found: ${extensions_file}" >&2
  exit 1
fi

user_data_dir="${OPENVSCODE_USER_DATA_DIR:-/config/data}"
extensions_dir="${OPENVSCODE_EXTENSIONS_DIR:-/config/extensions}"

resolve_openvscode_server_cmd() {
  if command -v openvscode-server >/dev/null 2>&1; then
    command -v openvscode-server
    return
  fi

  local configured_root="${OPENVSCODE_SERVER_ROOT:-}"
  local candidate=""
  for candidate in \
    "${configured_root:+${configured_root}/bin/openvscode-server}" \
    /app/openvscode-server/bin/openvscode-server \
    /home/.openvscode-server/bin/openvscode-server
  do
    if [[ -n "$candidate" && -x "$candidate" ]]; then
      printf '%s\n' "$candidate"
      return
    fi
  done

  echo "error: openvscode-server binary not found" >&2
  exit 1
}

normalize_extension_line() {
  local line="$1"
  line="${line%%#*}"
  line="$(printf '%s' "$line" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  printf '%s' "$line"
}

warn() {
  printf '[vscode-extensions] %s\n' "$*" >&2
}

openvscode_cmd="$(resolve_openvscode_server_cmd)"
mkdir -p "$user_data_dir" "$extensions_dir"

openvscode_install() {
  local extension="$1"
  "$openvscode_cmd" \
    --install-extension "$extension" \
    --user-data-dir "$user_data_dir" \
    --extensions-dir "$extensions_dir"
}

while IFS= read -r line || [[ -n "$line" ]]; do
  extension="$(normalize_extension_line "$line")"
  if [[ -z "$extension" ]]; then
    continue
  fi

  if ! openvscode_install "$extension"; then
    bare_id="${extension%@*}"
    if [[ "$bare_id" != "$extension" ]] && openvscode_install "$bare_id"; then
      continue
    fi
    warn "extension install failed: ${extension}"
  fi
done <"$extensions_file"
