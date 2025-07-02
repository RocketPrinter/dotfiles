def get-base-path [] { $env.HOME | path join .config dotfiles }

# Add file(s) and convert to symlink
export def add [
	...files: string 
	--template(-t) # Turns the file into a template
	--symbol(-s): string = '\$' # Symbol inserted in the regex used for identifying variables, only used if --template is selected
	--comment(-c): string = "# s" # Formatting to use for comment, only used if --template is selected
] {
	# Loading configs
	mut store_nuon = try { open (get-store-nuon-path) } catch { {files: []} }
	let vars = try { (open (get-local-config-path)).vars? } catch { {} }

	for concrete_path in $files {
		let concrete_path = ($concrete_path | path expand -n)
		let relative_path = ($concrete_path | path relative-to $env.HOME)
		let store_path = (to-store-path $relative_path)
			
		# Check that file is not in store, in the file or in the folder
		if ($store_nuon.files | any {|rec| $rec.path == $relative_path} ) or ($store_path | path exists) {
			error make {msg: "File already in store"}
		}

		# Copy file to store
		mkdir ($store_path | path dirname)
		mv -i $concrete_path $store_path

		# Modify and save store.nuon
		let rec = if $template { 
			{path: $relative_path, template: true, symbol: $symbol, comment: $comment} 
		} else { 
			{path: $relative_path, template: false} 
		}
			
		$store_nuon.files = ($store_nuon.files | append $rec)
		$store_nuon | save -f (get-store-nuon-path)

		apply-file $rec $vars
	}
}

# BAD IDEA, I don't want to accidentally delete my home directory

# Remove file(s) and restore original location
# export def remove [...files: string] { }

# Lists all dotfiles
export def "list files" [] { open (get-store-nuon-path) | get files }

# Lists all the variables used the template dotfiles
export def "list vars" [] {
	let kvp = try { (open (get-local-config-path)).vars? } catch { {} }
	open (get-store-nuon-path) 
	| get files 
	| where template == true
	| each {|row| 
		open --raw (to-store-path $row.path) 
		| extract-vars $row.symbol 
		| get -i trimmed
		| each {|e| [[var, file]; [$e,$row.path]] }
		}
	| flatten | flatten
	| insert value {|row| $kvp | get -i $row.var} 
}

# Builds all templates and places symlinks
export def apply [] {
	let vars = try { (open (get-local-config-path)).vars? } catch { {} }

	for rec in (open (get-store-nuon-path)).files {
		apply-file $rec $vars
	}
}

# Generate config-local.toml with parameters from templates
export def gen-local-config [--force(-f)] {
	let local_config_path = (get-local-config-path)
	if (not $force) and ($local_config_path | path exists) {  
		error make {msg: "config-local.toml already exists"}
	}
	
	open (get-store-nuon-path) 
	| get files 
	| where template == true 
	| each {|rec| 
		$env.HOME 
		| path join (to-store-path $rec.path) 
		| open --raw 
		| extract-vars $rec.symbol 
		| get -i trimmed 
		}
	| flatten
	| sort
	| each {|e| $"($e) = \"\"\n"}
	| prepend "[vars]\n"
	| str join
	| save $local_config_path -f
}

# cd to the folder
export def --env go [] { cd (get-base-path) }

def get-store-nuon-path [] { get-base-path | path join store.nuon }
def get-local-config-path [] { get-base-path | path join config-local.toml }
# paths must be relative to HOME
def to-store-path [relative_path: string] { get-base-path | path join store $relative_path }
def to-generated-path [relative_path: string] { get-base-path | path join .generated $relative_path }
 
# returns list<{raw: string, trimmed: string}>
def extract-vars [symbol: string]: string -> list<record> {
	parse -r $"\(?<raw>($symbol)\(?<trimmed>[A-Za-z0-9\\-\\_]+\)\)" | uniq
}

def apply-file [rec: record, vars: record] {
	let concrete_path = ($env.HOME | path join $rec.path)
	mkdir ($concrete_path | path dirname)
	# used to detect symlinks
	let expanded_path = ($concrete_path | path expand)

	let store_path = to-store-path $rec.path
	if not $rec.template {
		# we check that we aren't already pointing to the file
		if $expanded_path != $store_path {
			ln -s -b -v --suffix .backup $store_path $concrete_path
		}
	} else {
		let generated_path = to-generated-path $rec.path
		mkdir ($generated_path | path dirname)

		# creating .generated file
		let comment = ( ($rec.comment | str replace 's' $"DO NOT EDIT, file is generated from template at ($store_path)" ) + "\n" )
		mut file = ($comment + (open $store_path --raw) )
		let vars = ($file | extract-vars $rec.symbol | insert value {|row| $vars | get -i $row.trimmed } )
		for v in $vars {
			if $v.value? == null {
				print $"warning: variable \'($v.trimmed)\' not set"
				continue
			}
		
			$file = ($file | str replace --all $v.raw $v.value)
		}
		$file | save -f $generated_path

		# we check that we aren't already pointing to the file
		if $expanded_path != $generated_path {
			ln -s -b --suffix .backup $generated_path $concrete_path	
		}
	}
}
