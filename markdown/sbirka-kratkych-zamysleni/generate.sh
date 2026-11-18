#!/bin/bash
# This file is generated dynamically by copier
# @script: generate.sh
# @version: 2026-11-17.1

# Script used for generation of e-book releases

set -euo pipefail

while [ "$#" -gt 0 ]; do
  # OPTIONS
  if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "This script will update copier templates and generate "
    echo "current verision of the Sbírka krátkých zamyšlení e-book."
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "-h | --help    show usage and parameters of the script"
    echo "-x             bash debug output"
    exit 0
  elif [ "$1" = "-x" ]; then
    echo "Detected parameter $1 for bash debug output of the script"
    set -x
  else
    echo "Generating release: 2026-11-18 of e-book: Sbírka krátkých zamyšlení"
  fi

  shift
done

EBOOK_FOLDER_NAME=$(pwd | sed -e 's/.*\///g')

if ! mkdir -p "../../epub/${EBOOK_FOLDER_NAME}"; then
  echo "Failed to create epub directory ${EBOOK_FOLDER_NAME}"
  exit 1
fi

if ! mkdir -p "../../pdf/${EBOOK_FOLDER_NAME}"; then
  echo "Failed to create pdf directory ${EBOOK_FOLDER_NAME}"
  exit 1
fi

if ! sha1sum -c output/sha1sum-copier.txt; then
  echo "Copier templates not updated for Sbírka krátkých zamyšlení."
  exit 1
fi

if ! pandoc -f markdown -t epub \
  00. metadata.yml ./*.md \
  --toc --tod-depth=2 \
  --css=style.css \
  --epub-cover-image=cover.jpg \
  -o "../../epub/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.epub"; then
  echo "Failed to generate ../../epub/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.epub"
  exit 1
fi

if ! epubcheck "../../epub/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.epub"; then
  echo "Failed to validate ebook file ../../epub/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.epub"
  exit 1
fi

if ! pandoc -f markdown -t pdf \
  00. metadata.yml ./*.md \
  --pdf-engine=weasyprint \
  --toc --tod-depth=2 \
  --css=style.css \
  --epub-cover-image=cover.jpg \
  -o "../../pdf/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.pdf"; then
  echo "Failed to generate ../../pdf/${EBOOK_FOLDER_NAME}/${EBOOK_FOLDER_NAME}.pdf"
  exit 1
fi

echo "E-book files generated successfully"
exit 0

# vim: set filetype=bash :
# vim: set spelllang=en :
