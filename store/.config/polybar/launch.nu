#!/usr/bin/nu

def main [--toggle-focus] {
	cd '~/.config/polybar'

	# Terminate already running bar instances
	try { killall -q polybar }

	mut focusing = try { open focus_mode } catch { false } | into bool
	if $toggle_focus {
		$focusing = ($focusing == false)
		$focusing | save focus_mode -f
	}

	let monitors = xrandr -q 
	| find ' connected ' 
	| ansi strip 
	| parse "{name} connected {rest}" 
	| insert primary {|row| $row.rest | str starts-with "primary" }

	print $monitors

	for m in $monitors {
		let bar = (if $m.primary {"main"} else {"secondary"}) + (if $focusing {"_focus"} else {""})
		print $bar
		MONITOR=$m.name bash -c $"polybar --reload ($bar) &";
	}
}
