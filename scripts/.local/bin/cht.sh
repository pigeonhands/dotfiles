#!/usr/bin/env bash

topic=""
query_prompt=""

case "$1" in
"all")
	topic="~"
	query_prompt="query"
	;;
"")
	topic=$(curl -Ss cht.sh/:list | fzf)
	[ -z "$topic" ] && exit 1
	query_prompt="query for $topic"
	;;
*)
	topic="$1"
	query_prompt="query for $topic"
	;;
esac

query="${@:2}"

if [ -z "$query" ]; then
	read -r -p "$query_prompt: " query
fi

if [ -n "$query" ]; then
	query="$(echo "$query" | tr ' ' '+')"
	[ "$topic" = "~" ] || query="/$query"
fi

query_url="cht.sh/$topic$query"

echo "quering $query_url"
curl -Ss "$query_url"
