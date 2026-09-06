#!/usr/bin/env bash

. /etc/os-release

scripts=$(dirname "$0")

TARGET_OS=""

usage() {
	echo "usage: setup.sh [options] [filter]"
	echo ""
	echo "options:"
	echo "  --distro  Disro to install packages for"
	echo ""
}

while [[ $# -gt 0 ]]; do
	echo "ARG: \"$1\""
	case "$1" in
	"--arch")
		shift
		TARGET_OS="$1"
		;;
	--*)
		echo "unknown option: $1" >&2
		usage >&2
		exit 1
		;;
	*)
		;;
	esac
	shift
done

TARGET_OS="${TARGET_OS:-$ID}"

function install_arch_package() {
	pkg="$1"
	manager="${2:-pacman}"
	if ! $manager -Q "$pkg" &>/dev/null; then
		echo "($manager) Installing $pkg..."
		sudo $manager -S --noconfirm "$pkg"
	else
		echo "($manager) $pkg is already installed. Skipping."
	fi
}

function install_package() {
	package_name="$1"
	package_manager="$1"
	flavor_text=""

	if [[ "$package_name" == *:* ]]; then
		pacakge_manager="${package_name%%:*}"
		package_name="${package_name#*:}"
		flavor_text="(using $pacakge_manager)"
	fi

	echo "installing package $package_name for $TARGET_OS $flavor_text"

	case "$TARGET_OS" in
	arch) install_arch_package "$package_name" "$pacakge_manager" ;;
	*)
		echo "Unsupported os $TARGET_OS"
		exit 1
		;;
	esac
	echo ""
}

echo "Target Arch: ${TARGET_OS:-$ID}"

while IFS=':' read -r key val; do
	key=$(echo "$key" | tr -d ' \t-')
	# Strip leading/trailing whitespace from the value
	val=$(echo "$val" | xargs)

	if [ "$key" = "$TARGET_OS" ] && [ -n "$val" ]; then
		install_package "$val"
	fi
done <packages.yaml
