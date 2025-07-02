#!/usr/bin/nu

def get_window [] {
	let pids = (xdotool search --class "vesktop|discord" | lines)

	if ($pids | is-empty) {
		error make { msg: "Couldn't locate any discord windows" }
	}

	if ($pids | length) > 1 {
		print -e "Warning, more than one discord window exists, picking the first one"
	}

	$pids | get 0
}

def main [] {
	let cur_pid = xdotool getwindowfocus

	let discord_pid = get_window

	xdotool windowactivate --sync $discord_pid key ctrl+shift+m

	xdotool windowactivate $cur_pid
}
