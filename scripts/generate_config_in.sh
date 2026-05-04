#!/usr/bin/env bash
set -euo pipefail

usage() {
	echo "Usage: $0 <choice_prompt> <scan_root> <output_config_in>"
	echo "Config filename is fixed to: Config.in"
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
	usage
	exit 0
fi

if [[ $# -ne 3 ]]; then
	usage
	exit 1
fi

choice_prompt="$1"
scan_root="$2"
output_file="$3"
config_filename="Config.in"

if [[ ! -d "$scan_root" ]]; then
	echo "Error: scan root '$scan_root' does not exist or is not a directory." >&2
	exit 1
fi

mkdir -p "$(dirname "$output_file")"

tmp_file="$(mktemp)"
cleanup() {
	rm -f "$tmp_file"
}
trap cleanup EXIT

{
	echo "choice"
	echo "	prompt \"$choice_prompt\""
} > "$tmp_file"

found=0
while IFS= read -r cfg; do
	found=1
	cat "$cfg" >> "$tmp_file"
done < <(find "$scan_root" -type f -name "$config_filename" | sort)

if [[ "$found" -eq 0 ]]; then
	echo "Warning: no '$config_filename' found under '$scan_root'." >&2
fi

echo "endchoice" >> "$tmp_file"

mv "$tmp_file" "$output_file"
