#!/bin/bash

INPUT="$1"
OUTPUT="$2"
QUALITY="${3:-ebook}"

gs \
  -sDEVICE=pdfwrite \
  -dCompatibilityLevel=1.4 \
  -dPDFSETTINGS=/$QUALITY \
  -dNOPAUSE \
  -dQUIET \
  -dBATCH \
  -sOutputFile="$OUTPUT" \
  "$INPUT"
