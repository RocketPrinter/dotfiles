#!/usr/bin/nu

let workspaces = i3-msg -t get_workspaces | from json | get num | where $it != -1 | sort
mut index = 1
for w in $workspaces {
	print $w
	if $w != $index {
		i3-msg -t run_command workspace $index
		exit
	}

	$index += 1
}
i3-msg -t run_command workspace $index
