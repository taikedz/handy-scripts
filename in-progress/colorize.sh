#To colorize, you need to use echo with escapes

echo          ' Colour ID        echo "\033[0;$i"mlight text           echo "\033[1;$i"mbold text'

for i in {3,4} {30..47}; do
cat << EOF
$(echo -e     " Colour $i         \033[0;$i"mlight text"                            \033[1;$i"mbold text" \033[0;0m")
EOF
done
echo -e "\033[0;0m" # reset
