#!/usr/bin/env bash

set -euo pipefail

# Path to your saved Brewfile
SAVED_BREWFILE="${1:-Brewfile}"

if [[ ! -f "$SAVED_BREWFILE" ]]; then
  echo "Error: Brewfile not found at $SAVED_BREWFILE"
  exit 1
fi

# Create temp directory
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

CURRENT_BREWFILE="$TEMP_DIR/Brewfile.current"
SAVED_SORTED="$TEMP_DIR/Brewfile.saved.sorted"
CURRENT_SORTED="$TEMP_DIR/Brewfile.current.sorted"

# Dump current state
brew bundle dump --file="$CURRENT_BREWFILE" --force

# Sort both files (brew entries only, ignore comments/empty lines/vscode)
grep -v '^#\|^$' "$SAVED_BREWFILE" | grep -v '^vscode ' | sort > "$SAVED_SORTED"
grep -v '^#\|^$' "$CURRENT_BREWFILE" | grep -v '^vscode ' | sort > "$CURRENT_SORTED"

# Find differences
MISSING=$(comm -23 "$SAVED_SORTED" "$CURRENT_SORTED")
EXTRA=$(comm -13 "$SAVED_SORTED" "$CURRENT_SORTED")

if [[ -z "$MISSING" && -z "$EXTRA" ]]; then
  echo "✓ No differences found"
  exit 0
fi

if [[ -n "$MISSING" ]]; then
  echo "Missing (in saved but not installed):"
  echo "$MISSING" | sed 's/^/  /'
  echo
fi

if [[ -n "$EXTRA" ]]; then
  echo "Extra (installed but not in saved):"
  echo "$EXTRA" | sed 's/^/  /'
fi