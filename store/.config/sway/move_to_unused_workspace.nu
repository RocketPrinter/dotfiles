#!/usr/bin/nu

let workspaces = swaymsg -rt get_workspaces | from json | get num | where $it != -1 | sort
mut index = 1
for w in $workspaces {
	print $w
	if $w != $index {
		swaymsg workspace $index
		exit
	}

	$index += 1
}
swaymsg workspace $index
