# Helper for managing python virtual environments
# List your virtual environments in a $HOME/.virtualenvs file as pairs
# Each pair can be either of `<label>:<path>` or `<label><tab><path>`

# INSTALL:
#
# Add this file to your home folder for example ~/.bashrc.d/
# And in .basrch , ensure you have `. ~/bashrc.d/*rc`


# ---
# Format for virtualenvs file:
#
#	label:/path/to/venv
#	label2:/other/path/to/venv
#
#	# Comments are supported
#	label3	/tab/separated/item
#
# Any one path $vpath must have a $vpath/bin/activate to be recognized as valid
# ---


# Only define the functions if a virtualenvs file is defined in the first place !
if [ -f "$HOME/.virtualenvs" ]; then
	# This allows use of a file of pair listings, as well as supporting blank lines and comment lines
	VIRTUAL_ENVIRONMENT_LIST="$(grep -Pv '^\s*#?\s*$' "$HOME/.virtualenvs"|sed -r 's/\t/:/g')"

	venv() {
		local actionp="^(activate|use|end|list)$"
		[[ "$1" =~ $actionp ]] || {
			echo "Invalid action. Use [venv activate|use|list ENVNAME]" >&2
			return 1
		}

		if [ "$1" = list ]; then
			venv_list_envs
		elif [ "$1" = use ] || [ "$1" = activate ]; then
			venv_activate_env "$2"
		elif [ "$1" = end ]; then
			deactivate
		else
			echo "Invalid action." >&2
			return 1
		fi
	}

	venv_activate_env() {
		local actpath="$(venv_get_path "$1")"

		[[ -n "$actpath" ]] || return

		[[ -f "$actpath/bin/activate" ]] || {
			echo "Invalid path $actpath" >&2
			return 2
		}

		. "$actpath/bin/activate" || return 1

		echo -e "----\n\tVirtual environment activated\n\nType 'deactivate' or 'venv end' to return to default environment, or 'exit' to close the shell. \n----" >&2
	}

	venv_get_path() {
		local res="$(echo "$VIRTUAL_ENVIRONMENT_LIST"|grep "^$1:" -P)"

		[[ -n "$res" ]] || {
			echo "No such virtual environment $1" >&2
			return 1
		}

		if [ $(echo "$res"|wc -l) -gt 1 ]; then
			echo -e "Too many results:\n\n$res" >&2
			return 2
		fi

		echo "$res"|cut -d: -f2
	}

	venv_list_envs() {
		echo "$VIRTUAL_ENVIRONMENT_LIST" | sed 's/:/\t/g'
	}
else
	echo -e "\033[33;1mNot loading virtual environment shortcuts without a $HOME/.virtualenvs file\033[0m" >&2
fi

# vim: set filetype=sh:
