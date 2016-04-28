
	for x in secdir.enc/*; do
		if [[ -d "$x" ]]; then
			x="$(basename $x)"
			echo "$x"
			ps aux | grep "^$(whoami).+$x" | grep -v grep # display any currently open items
		fi
	done
	exit 0
