#!/usr/bin/env bash

set -eo pipefail

BREWFILE="${1:-Brewfile}"

if [[ ! -f "$BREWFILE" ]]; then
  echo "Error: Brewfile not found at $BREWFILE"
  exit 1
fi

show_help() {
    cat << EOF
Usage: brew-add [Brewfile]

Interactively select brews and casks to add to your Brewfile.

Arguments:
  Brewfile    Path to Brewfile (default: Brewfile)

The script will:
  1. Run brew-diff logic to find extra items (installed but not in Brewfile)
  2. Display available brews and casks with clear labels
  3. Allow multiselection using fzf
  4. Add selected items to the Brewfile

Examples:
  brew-add                    # Use default Brewfile
  brew-add MyBrewfile         # Use custom Brewfile
EOF
}

get_diff_items() {
    # Use same logic as brew-diff.sh to find extra items
    TEMP_DIR=$(mktemp -d)
    trap 'rm -rf "$TEMP_DIR"' EXIT
    
    CURRENT_BREWFILE="$TEMP_DIR/Brewfile.current"
    SAVED_SORTED="$TEMP_DIR/Brewfile.saved.sorted"
    CURRENT_SORTED="$TEMP_DIR/Brewfile.current.sorted"
    
    # Dump current state
    brew bundle dump --file="$CURRENT_BREWFILE" --force
    
    # Sort both files (brew entries only, ignore comments/empty lines/vscode)
    grep -v '^#\|^$' "$BREWFILE" | grep -v '^vscode ' | sort > "$SAVED_SORTED"
    grep -v '^#\|^$' "$CURRENT_BREWFILE" | grep -v '^vscode ' | sort > "$CURRENT_SORTED"
    
    # Find extra items (installed but not in saved)
    # Handle case where either file might be empty
    if [[ -s "$SAVED_SORTED" && -s "$CURRENT_SORTED" ]]; then
        comm -13 "$SAVED_SORTED" "$CURRENT_SORTED"
    elif [[ -s "$CURRENT_SORTED" ]]; then
        # If saved is empty but current has items, all current items are extra
        cat "$CURRENT_SORTED"
    else
        # Both files are empty or current is empty, no extra items
        :
    fi
}

select_items() {
    local items="$1"
    local header="$2"
    
    if [[ -z "$items" ]]; then
        return 0
    fi
    
    echo "$items" | fzf -m --header="$header" || true
}

add_to_brewfile() {
    local type="$1"
    local items="$2"
    
    if [[ -z "$items" ]]; then
        return 0
    fi
    
    # Use here-string instead of pipe to avoid stdin issues
    while IFS= read -r item; do
        if [[ -n "$item" ]]; then
            echo "$type \"$item\"" >> "$BREWFILE"
            echo "Added $type \"$item\" to $BREWFILE"
        fi
    done <<< "$items"
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help|help)
            show_help
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            show_help
            exit 1
            ;;
        *)
            BREWFILE="$1"
            shift
            ;;
    esac
done

# Get diff items (installed but not in Brewfile)
diff_items=$(get_diff_items)

if [[ -z "$diff_items" ]]; then
    echo "✓ No extra items found to add"
    exit 0
fi

echo "separating items"

# Separate brews and casks with clear labels
brew_items=$(echo "$diff_items" | grep '^brew "' | sed 's/^brew "//' | sed 's/"$//' || true)
cask_items=$(echo "$diff_items" | grep '^cask "' | sed 's/^cask "//' | sed 's/"$//' || true)

# Display what's available
echo "Available items to add:"
echo "$diff_items" | sed 's/^/  /'
echo

# Select items to add
if [[ -n "$brew_items" ]]; then
    selected_brews=$(select_items "$brew_items" "Select brews to add (TAB to multiselect)")
else
    selected_brews=""
fi

if [[ -n "$cask_items" ]]; then
    selected_casks=$(select_items "$cask_items" "Select casks to add (TAB to multiselect)")
else
    selected_casks=""
fi

# Add selected items to Brewfile
add_to_brewfile "brew" "$selected_brews"
add_to_brewfile "cask" "$selected_casks"

if [[ -n "$selected_brews" || -n "$selected_casks" ]]; then
    echo
    echo "✓ Added items to $BREWFILE"
else
    echo "No items selected"
fi
