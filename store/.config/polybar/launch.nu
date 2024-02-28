#!/usr/bin/nu
# Terminate already running bar instances
try { killall -q polybar }

let monitors = xrandr -q 
| find ' connected ' 
| ansi strip 
| parse "{name} connected {rest}" 
| where name != 'None-1-1' # for some reason this exists and must be filtered out
| insert primary {|row| $row.rest | str starts-with "primary" }

for m in $monitors {
	MONITOR=$m.name bash -c $"polybar --reload (if $m.primary {"main"} else {"mini"})&";
}
