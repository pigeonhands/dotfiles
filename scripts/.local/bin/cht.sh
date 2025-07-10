#!/usr/bin/env bash

topic=$(curl cht.sh/:list | fzf)
[ -z "$topic" ] && exit 1

read -r -p "query for $topic: " query

if [ -n "$query" ]; then
	query="/$(echo "$query" | tr ' ' '+')"
fi

curl cht.sh/$topic$query
