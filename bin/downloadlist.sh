echo "Processing $1 ..."

matcher='https://(www.)?youtube.com'
[[ $1 =~ $matcher ]] && {
	echo "Downloading from $1"
	for ytid in $(youtube-dl "$1" --flat-playlist -J | sed -r -e 's/\}, \{/\},\n\{/g' -e 's/(\]|\[)/\1\n/g' | sed -r -e 's/^.+"id": "([^"]+)".+$/\1/g' |grep -E '^.{11}$'); do
		youtube-dl 'https://youtube.com/watch?v='$ytid
		echo "--------"
	done
}
