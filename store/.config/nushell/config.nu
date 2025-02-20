# Nushell Config File

$env.config = {
	show_banner : false,
	buffer_editor : micro,	
}

source ~/.config/nushell/aliases.nu
source ~/.zoxide.nu
source ~/.local/share/atuin/init.nu

use ~/.cache/starship/init.nu
use ~/.config/dotfiles
