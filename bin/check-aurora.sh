# From : https://publicapis.io/auroras-live-science-api
# pointing at
# http://auroraslive.io/#/api/v1

COORDS_EDINBURGH="lat=55.953251&long=-3.188267"
URL="https://api.auroras.live/v1/?type=ace&data=probability&$COORDS_EDINBURGH"

tfile="$(mktemp /tmp/aurora.XXXXX)"

curl -s "$URL" > "$tfile"

_jq() { jq -r -M "$@" < "$tfile" ; }

DATE="$(_jq .date)"

VIEW_VALUE="$(_jq .value)"

VIEW_COLOR="$(_jq .colour)"

case "$VIEW_COLOR" in
green)
    CLR=32
    ;;
red)
    CLR=31
    ;;
*)
    CLR=33
    ;;
esac

print_rating() {
    echo -e "Auroroa rating : \033[${CLR};1m$VIEW_VALUE $VIEW_COLOR\033[0m @ $DATE"
}

print_rating

CLR=0

print_rating > ~/.local/var/aurora.txt

