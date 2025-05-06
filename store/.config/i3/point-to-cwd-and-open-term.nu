#!/usr/bin/nu
job spawn { sleep 0.05sec; xdotool click 1 }
mut pid = (xprop _NET_WM_PID | parse "_NET_WM_PID(CARDINAL) = {pid}" | get pid.0 | into int)

mut cwd = null 
loop {
	let child = ps -l | select pid ppid cwd | where ppid == $pid | get -i 0 	
	if $child == null { 
		break
	}
	$cwd = $child.cwd
	$pid = $child.pid
}

if $cwd == null {
	error make {msg: "Failed to get cwd"}
}

print $"pid: ($pid) cwd:($cwd)"

alacritty --working-directory $cwd
