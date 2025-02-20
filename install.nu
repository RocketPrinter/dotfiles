export def main [] {
	packages; aur; misc; rofi
}

# Dependency installation script
export def packages [] {
	const packages = [arandr, alacritty, asciinema, bat, blender, bottom, chromium, copyq, cowsay, deluge-gtk, docker, dotnet-sdk, ffmpeg, filelight, flameshot, github-cli, gnome-keyring, gource, gwenview, helvum, hexyl, htop, i3-wm, i3lock-color, krita, lolcat, lutris, lynx, micro, wild, nano, nemo, nemo-compare, nemo-fileroller, nemo-seahorse, neofetch, nmap, nushell, obsidian, pavucontrol, picom, piper, polybar, psensor, qalculate-gtk, reaper, rofi, rofimoji, rustup, sl, starship, steam, tailscale, telegram-desktop, thefuck, toilet, udiskie, xorg-apps, yt-dlp, lxappearance-gtk3, bluez, bluez-utils, gucharmap, jre-openjdk, tela-icon-theme, noto-fonts, noto-fonts-cjk, noto-fonts-emoji, noto-fonts-extra, ttf-nerd-symbols, ttf-nerd-symbols-common, ttf-opensans, ttf-symbola, smartmontools, p7zip, i3-wm, xss-lock, dunst, man-db, gdb, playerctl, traceroute, yt-dlp,  ntfs-3g, rsync, meld, yazi, zoxide, fd, termshark, binsider, gitui, btop, atuin]

	if (which paru | length) == 0 { install-paru }
	paru -Sy --needed ...$packages
}

export def aur [] {
	const aur_packages = [paru, downgrade, onlyoffice-bin, clion, graphite-gtk-theme, xkb-switch, selectdefaultapplication-git, i3lock-color, insomnia-bin, vesktop-bin, zen-browser]

	if (which paru | length) == 0 { install-paru }
	for pkg in $aur_packages {
		try {	
			paru -S --sudoloop --skipreview --needed $pkg
		}
	}
}

export def misc [] {
	sudo localectl set-x11-keymap us,ro pc104
	gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
}

export def rofi [] {
	mkdir /temp/dotfiles
	cd /temp/dotfiles
	git clone --depth=1 https://github.com/adi1090x/rofi.git
	./rofi/setup.sh
	let powermenu = $"($env.HOME)/.config/rofi/powermenu/type-5/powermenu.sh"
	open $powermenu | str replace -r "i3lock(?!').*$" 'i3lock -B 5 -k --time-color=FFFFFF --date-color=FFFFFF' | save -f $powermenu
}

export def install-paru [] {
	print "Installing paru"
	mkdir /tmp/dotfiles
	cd /tmp/dotfiles
	sudo pacman -S --needed base-devel
	sudo git clone https://aur.archlinux.org/paru.git
	sudo chmod -R a+rwx paru
	cd paru
	makepkg -si
}
