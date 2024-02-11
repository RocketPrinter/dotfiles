# Dependency installation script
export def install-packages [] {
	const packages = [alacritty, asciinema, bat, blender, bottom, chromium, copyq, cowsay, deluge-gtk, discord, docket, dotnet-sdk, ffmpeg, filelight, firefox, flameshot, github-cli, gnome-keyring, gource, gwenview, helvum, hexyl, htop, i3-wm, i3lock-color, krita, lf, lolcat, lutris, lynx, micro, mold, nano, nemo, nemo-compare, nemo-fileroller, nemo-seahorse, neofetch, nmap, nushell, obsidian, pavucontrol, picom, piper, polybar, psensor, qalculate-gtk, reaper, rofi, rofimoji, rustup, sl, starship, steam, tailscale, telegram-desktop, thefuck, toilet, udiskie, yt-dlp]

	const aur_packages = [paru, downgrade, onlyoffice-bin, clion]

	if (which paru | length) == 0 { install-paru }

	print "installing pacman packages"
	paru -Sy ...$packages

	print "installing aur packages"
	paru -Sy ...$aur_packages
}

def install-paru [] {
	print "Installing paru"
	mkdir /temp/dotfiles
	cd /temp/dotfiles
	sudo pacman -S --needed base-devel
	git clone https://aur.archlinux.org/paru.git
	cd paru
	makepkg -si
}
