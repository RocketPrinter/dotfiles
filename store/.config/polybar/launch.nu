#!/usr/bin/nu
# Terminate already running bar instances
try { killall -q polybar }

let monitors = xrandr -q 
| find ' connected ' 
| ansi strip 
| parse "{name} connected {rest}" 
| insert primary {|row| $row.rest | str starts-with "primary" }

print $monitors

for m in $monitors {
	let bar = if $m.primary {"main"} else {"mini"}
	MONITOR=$m.name bash -c $"polybar --reload ($bar) &";
}
