#!/bin/zsh
# Re-vendor python_snoo from the fork into custom_components/snoo/python_snoo.
# Usage: scripts/vendor_python_snoo.sh [path-to-python-snoo-checkout]   (default ~/Repository/python-snoo)
set -e
SRC=${1:-$HOME/Repository/python-snoo}
DST=$(cd "$(dirname "$0")/.." && pwd)/custom_components/snoo/python_snoo
[ -d "$SRC/python_snoo" ] || { echo "no python_snoo package at $SRC" >&2; exit 1; }
rm -rf "$DST"; cp -R "$SRC/python_snoo" "$DST"; find "$DST" -name __pycache__ -type d -prune -exec rm -rf {} +
echo "jasperchan/python-snoo $(git -C "$SRC" branch --show-current) @ $(git -C "$SRC" rev-parse --short HEAD)" > "$DST/VENDORED_FROM"
cat "$DST/VENDORED_FROM"
