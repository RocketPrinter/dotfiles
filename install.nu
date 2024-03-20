export def main [] {
	packages; aur; misc
}

# Dependency installation script
export def packages [] {
	const packages = [arandr, alacritty, asciinema, bat, blender, bottom, chromium, copyq, cowsay, deluge-gtk, discord, docket, dotnet-sdk, ffmpeg, filelight, firefox, flameshot, github-cli, gnome-keyring, gource, gwenview, helvum, hexyl, htop, i3-wm, i3lock-color, krita, lf, lolcat, lutris, lynx, micro, mold, nano, nemo, nemo-compare, nemo-fileroller, nemo-seahorse, neofetch, nmap, nushell, obsidian, pavucontrol, picom, piper, polybar, psensor, qalculate-gtk, reaper, rofi, rofimoji, rustup, sl, starship, steam, tailscale, telegram-desktop, thefuck, toilet, udiskie, xorg-apps, yt-dlp, lxappearance-gtk3, bluez, bluez-utils, gucharmap, jre-openjdk, tela-icon-theme, noto-fonts, noto-fonts-cjk, noto-fonts-emoji, noto-fonts-extra, ttf-nerd-symbols, ttf-nerd-symbols-common, ttf-opensans, ttf-symbola, smartmontools, p7zip, i3-wm, xss-lock, dunst, man-db, playerctl]

	if (which paru | length) == 0 { install-paru }
	paru -Sy --needed ...$packages
}

export def aur [] {
	const aur_packages = [paru, downgrade, onlyoffice-bin, clion, graphite-gtk-theme, xkb-switch, selectdefaultapplication-git, i3lock-color]

	if (which paru | length) == 0 { install-paru }
	for pkg in $aur_packages {
		try {	
			paru -S --sudoloop --skipreview --needed $pkg
		}
	}
}

export def misc [] {
	sudo localectl set-x11-keymap us,ro pc104
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
