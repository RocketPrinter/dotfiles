# renames
alias cls    = clear
alias puro   = paru
alias m      = micro
alias bottom = btm
alias repl   = evcxr

# replacing cat with bat
alias cat = bat

# polybar
def polybar-show-wifi [] { open --raw ~/.config/polybar/config.ini | str replace -r '直%{F-}(?!\ )' '直%{F-} %essid%' | save ~/.config/polybar/config.ini -f }
def polybar-hide-wifi [] { open --raw ~/.config/polybar/config.ini | str replace '直%{F-} %essid%' '直%{F-}' | save ~/.config/polybar/config.ini -f }

# utilities
alias brightness = sudo micro /sys/class/backlight/intel_backlight/brightness
alias bt = bluetoothctl
def btdc [] { echo "disconnect" | bluetoothctl }
def bth  [] { echo "power on\nconnect 30:53:C1:66:A9:BB" | bluetoothctl }
alias lock = light-locker-command -l
alias hibernate = systemctl hibernate
alias wifi = nmcli device wifi
alias hotspot = nmcli device wifi connect "Duba SRI"
alias pachelp = xdg-open https://wiki.archlinux.org/title/pacman
alias paclogs = m /var/log/pacman.log
alias fuckteams = pkill -f teams
# alias grayscale = bash $HOME/.config/polybar/toggle-monitor-grayscale.sh
def gource-ffmpeg [] { gource -f -a 1 -c 4 -r 60 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -s 1920x1080 -preset fast -crf 18 -threads 0 -bf 0 -pix_fmt yuv420p -movflags +faststart output.mp4 }
alias gitlog = git log --online --graph
def m-all-files [path: string = ""] { cd $path; m ...(ls | get name | filter {|x| $x =~ '\.'}) };
def discord-cache-links [until: datetime, take: int = 10] { 
	echo $"Cache files before ($until):"; 
	ls ~/.config/discord/Cache/Cache_Data/ 
	| sort-by -r modified 
	| where type == file and modified < $until 
	| take $take 
	| insert link {|row| (strings $row.name | lines).0 | str substring 4.. | str replace -r "\\?.*" ""} 
	| select modified link
}

# fun uwu
def gmatrix  [] { cmatrix | lolcat -p 5 -F 0.0005 -i }
def gay      [] { echo "So gay~~" | toilet --rainbow }
def owo      [] { echo "OwO" | toilet --rainbow }
def uwu      [] { echo "UwU" | toilet --rainbow }
def hello    [] { echo "Hello!" | toilet --rainbow }
def telehack [] { telnet telehack.com | lolcat -p 5 -F 0.005 }
