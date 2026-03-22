#!/usr/bin/env bash

DOTFILES_CACHE="${DOTFILES_CACHE:-.dotfiles-cache}"
AGE_RECIPIENTS_FILE="${AGE_RECIPIENTS_FILE:-.age-recipients}"

scripts=$(dirname "$0")
cd "$scripts/.."

find_recipients() {
	local file="$1"
	local dir="$(dirname "$file")"
	while [[ "$dir" != "." ]] && [[ "$dir" != "/" ]]; do
		if [[ -f "$dir/.age-recipients" ]]; then
			echo "$dir/.age-recipients"
			return
		fi
		dir="$(dirname "$dir")"
	done
	echo "$AGE_RECIPIENTS_FILE"
}

encrypt() {
	find "$DOTFILES_CACHE" -type f 2>/dev/null | while read cached; do
		local rel="${cached#$DOTFILES_CACHE/}"
		local src="$rel.age"
		if [ -f "$src" ] && [ "$cached" -nt "$src" ]; then
			local recipients="$(find_recipients "$src")"
			echo "Encrypting $src (recipients: $recipients)"
			age --encrypt --recipients-file "$recipients" -o "$src" "$cached"
		fi
	done
}

watch() {
	inotifywait -m -e close_write -r "$DOTFILES_CACHE" --format '%w%f' 2>/dev/null | \
	while read f; do
		local rel="${f#$DOTFILES_CACHE/}"
		local src="$rel.age"
		if [ -f "$src" ]; then
			local recipients="$(find_recipients "$src")"
			echo "Re-encrypting $src (recipients: $recipients)"
			age --encrypt --recipients-file "$recipients" -o "$src" "$f"
		fi
	done
}

add_secret() {
	local in="$1"
	local out="$2"
	if [ -z "$in" ] || [ -z "$out" ]; then
		echo "usage: age.sh add-secret <in> <out>" >&2
		exit 1
	fi
	local recipients="$(find_recipients "$out")"
	mkdir -p "$(dirname "$out")"
	age --encrypt --recipients-file "$recipients" -o "$out.age" "$in"
	echo "Encrypted $in -> $out.age (recipients: $recipients)"
}

command="$1"
shift

case "$command" in
"encrypt")    encrypt ;;
"watch")      watch ;;
"add-secret") add_secret "$@" ;;
*)
	echo "Unknown command: $command" >&2
	echo "usage: age.sh <encrypt|watch|add-secret>" >&2
	exit 1
	;;
esac
