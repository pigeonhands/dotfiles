#!/bin/bash

function copy_file() {
	cp ~/$1 ./$1
}

function copy_dir() {
	cp -r ~/$1/* ./$1/
}

copy_file ".zshrc"
copy_file ".zsh_plugins.txt"
copy_dir ".config/zsh"
copy_dir ".config/alacritty"
copy_dir ".config/nvim"
