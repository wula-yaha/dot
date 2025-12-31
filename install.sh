#!/usr/bin/env sh

set -eu

dotdir=$(cd "$(dirname "$0")" && pwd)

detect_os() {
	detected_os="Unknown"
	if uname -r | grep -q -i "microsoft"; then
		detected_os="WSL"
	elif [ -f /proc/version ] && grep -q -i "microsoft" /proc/version; then
		detected_os="WSL"
	else
		case "$(uname -s)" in
		Linux)
			detected_os="Linux"
			;;
		Darwin)
			detected_os="macOS"
			;;
		*BSD)
			detected_os="BSD"
			;;
		esac
	fi
	echo "$detected_os"
}

link_file() {
	source=$1
	destination=$2

	# Source file existence checking
	if [ ! -e "$source" ]; then
		echo "$source not found, skipping: $source" >&2
		return 0
	fi

	# Parent directory existence checking
	mkdir -p "$(dirname "$destination")"

	# If the destination path is already occupied, back up
	# the existing item unless it is already the correct symbolic link.
	if [ -L "$destination" ]; then
		current_target=$(readlink "$destination")
		if [ "$current_target" = "$source" ]; then
			echo "$destination is already linked to the correct file."
			return 0
		fi
	fi
	if [ -e "$destination" ] && [ ! -L "$destination" ]; then
		timestamp=$(date +'%Y%m%d-%H%M%S')
		backup="${destination}.bak.${timestamp}"
		echo "Backup: $destination -> $backup"
		mv "$destination" "$backup"
	fi

	# Softlink creating
	echo "Link $destination -> $source"
	ln -snf "$source" "$destination"
}

main() {

	os=$(detect_os)

	# Neovim
	link_file "$dotdir/nvim/init.lua" "$HOME/.config/nvim/init.lua"

	# VSCode
	if [ "$os" = "macOS" ]; then
		link_file "$dotdir/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
		link_file "$dotdir/vscode/keybindings.json" "$HOME/Library/Application Support/Code/User/keybindings.json"
	else
		link_file "$dotdir/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
		link_file "$dotdir/vscode/keybindings.json" "$HOME/.config/Code/User/keybindings.json"
	fi

	# WezTerm
	link_file "$dotdir/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"

}

main
