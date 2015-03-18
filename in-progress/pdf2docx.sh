#!/bin/bash

# Dependencies - Ubuntu
# pdftohtml (from poppler-utils)
# gnuhtml2latex
# pandoc

# ======== Define vars

TMPFILE=/tmp/convert-pdf2docx-$(date +%F-T-%T | base64)

[[ -f "$1" ]] || { echo  "Input file $1 does not exist"; exit 1; }
[[ 'x' != "x$3" ]] && TMPFILE="$3"

PDFNAME="$1"
DOCNAME="$2"

# First convert PDF to HTML
echo "Converting to HTML ..."
pdftohtml -nomerge -noframes -s -i "$PDFNAME" "$TMPFILE"

echo "Fixing quirks ..."
sed -e "s,</b><br/>\$,</b><br/><br/>,g" -e "s,^<b>,<br/><b>,g" -e "s,\&#160;, ,g" -e "s, <br/>,<br/>,g" -i "$TMPFILE.html"
sed -r -e 's/\<!--.+?--\>//g' -e 's/^<--$//g' -e 's/^-->$//g' -i "$TMPFILE.html"

echo "Converting to LaTeX ..."
gnuhtml2latex "$TMPFILE.html" #> "$TMPTEX"

echo "Converting to DOCX ..."
pandoc -f latex -t docx "$TMPFILE.tex" -o "$DOCNAME"

echo "--- Done ---"
