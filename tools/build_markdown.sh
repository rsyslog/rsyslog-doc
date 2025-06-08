#!/bin/bash

# Build single-page HTML from the Sphinx sources and convert it to Markdown
# for AI ingestion.

set -euo pipefail

command -v pandoc >/dev/null 2>&1 || {
    echo "[!] pandoc is required but not installed" >&2
    exit 1
}

BUILD_DIR="build_markdown"
HTML_DIR="$BUILD_DIR/singlehtml"
MD_FILE="$BUILD_DIR/rsyslog-doc.md"

rm -rf "$BUILD_DIR"
mkdir -p "$HTML_DIR"

# Build single-page HTML
sphinx-build -b singlehtml source "$HTML_DIR"

# Convert HTML to Markdown
pandoc "$HTML_DIR/index.html" -f html -t gfm -o "$MD_FILE"

echo "Markdown output written to $MD_FILE"
