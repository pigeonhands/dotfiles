#!/usr/bin/env bash

DOTFILES_CACHE="${DOTFILES_CACHE:-.dotfiles-cache}"
AGE_RECIPIENTS_FILE="${AGE_RECIPIENTS_FILE:-.age-recipients}"

scripts=$(dirname "$0")
cd "$scripts/.."

encrypt() {
	find "$DOTFILES_CACHE" -type f 2>/dev/null | while read cached; do
		rel="${cached#$DOTFILES_CACHE/}"
		src="$rel.age"
		if [ -f "$src" ] && [ "$cached" -nt "$src" ]; then
			echo "Encrypting $src"
			age --encrypt --recipients-file "$AGE_RECIPIENTS_FILE" -o "$src" "$cached"
		fi
	done
}

watch() {
	inotifywait -m -e close_write -r "$DOTFILES_CACHE" --format '%w%f' 2>/dev/null | \
	while read f; do
		rel="${f#$DOTFILES_CACHE/}"
		src="$rel.age"
		if [ -f "$src" ]; then
			echo "Re-encrypting $src"
			age --encrypt --recipients-file "$AGE_RECIPIENTS_FILE" -o "$src" "$f"
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
	mkdir -p "$(dirname "$out")"
	age --encrypt --recipients-file "$AGE_RECIPIENTS_FILE" -o "$out.age" "$in"
	echo "Encrypted $in -> $out.age"
}

command="$1"
shift

case "$command" in
"encrypt")   encrypt ;;
"watch")     watch ;;
"add-secret") add_secret "$@" ;;
*)
	echo "Unknown command: $command" >&2
	echo "usage: age.sh <encrypt|watch|add-secret>" >&2
	exit 1
	;;
esac
