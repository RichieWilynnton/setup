#!/bin/bash

backup_file() {
    if [ -f "~/$1" ]; then
        mv "~/$1" "~/$1.bak"
        echo "Backed up ~/$1 to ~/$1.bak"
    fi
}
