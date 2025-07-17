#!/bin/bash

run_with_priv() {
    if [ "$(id -u)" -eq 0 ]; then
        "$@"
    elif command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        echo "Error: Need root privileges but sudo is not available"
        exit 1
    fi
}

detect_package_manager() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v apt-get &> /dev/null; then
            echo "apt"
        elif command -v dnf &> /dev/null; then
            echo "dnf"
        elif command -v pacman &> /dev/null; then
            echo "pacman"
        elif command -v zypper &> /dev/null; then
            echo "zypper"
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            echo "brew"
        else
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi
}

install_packages() {
    local pkg_manager="$1"
    shift
    local packages=("$@")

    case "$pkg_manager" in
        apt)
            run_with_priv apt-get update
            run_with_priv apt-get install -y "${packages[@]}"
            ;;
        dnf)
            run_with_priv dnf install -y "${packages[@]}"
            ;;
        pacman)
            run_with_priv pacman -Sy --noconfirm "${packages[@]}"
            ;;
        brew)
            brew install "${packages[@]}"
            ;;
        *)
            echo "Unknown package manager: $pkg_manager"
            exit 1
            ;;
    esac
}
