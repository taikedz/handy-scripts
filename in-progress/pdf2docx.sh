#!/bin/bash

# Dependencies - Ubuntu
# pdftohtml (from poppler-utils)
# gnuhtml2latex
# pandoc

# TODO
#
# * Add support for CentOS
#
# Dependencies - CentOS
# pdftohtml (from poppler-utils)
# html2latex (from perl-HTML-Latex.noarch)
#     this is a perl script, the arch version of gnuhtml2latex
#     is minimal with a singe source file
# pandoc (from 3rd party repo EPEL)

# ======== Define vars

TMPFILE=/tmp/convert-pdf2docx-$(date +%F-T-%T | base64)

[[ -f "$1" ]] || { echo  "Input file $1 does not exist"; exit 1; }
[[ 'x' != "x$3" ]] && TMPFILE="$3"

PDFNAME="$1"
DOCNAME="$2"

# First convert PDF to HTML
echo "Converting to HTML ..." # this adds a Document outline - we really want rid of it... cleanly...
pdftohtml -nomerge -noframes -s -i "$PDFNAME" "$TMPFILE"

echo "Fixing quirks ..."
sed -e "s,</b><br/>\$,</b><br/><br/>,g" -e "s,^<b>,<br/><b>,g" -e "s,\&#160;, ,g" -e "s, <br/>,<br/>,g" -i "$TMPFILE.html"
sed -r -e 's/\<!--.+?--\>//g' -e 's#<([a-zA-Z0-9_-]+).*?>\s*([^a-ZA-Z0-9])\s*</\1>##g' -i "$TMPFILE.html"
sed -e '/<a name="outline"><\/a><h1>Document Outline<\/h1>/,$ d' -i "$TMPFILE.html"
echo "</body>/<html>" >> "$TMPFILE.html"

echo "Converting to LaTeX ..."
gnuhtml2latex -S style "$TMPFILE.html" #> "$TMPTEX"

echo "Converting to DOCX ..."
pandoc -f latex -t docx "$TMPFILE.tex" -o "$DOCNAME"

echo "--- Done ---"
