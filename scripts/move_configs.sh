#!/bin/bash
source "$(pwd)/scripts/move_configs_h.sh"

for file in .*; do
    [[ "$file" == "." || "$file" == ".." || "$file" == ".git" ]] && continue
    backup_file "$file"
    cp -r "$file" ~/
done

EXPORTS_FILE=~/.zsh_exports_temp

if [[ -f "$EXPORTS_FILE" ]]; then
    cat "$EXPORTS_FILE" >> ~/.zshrc
    rm "$EXPORTS_FILE"
fi
