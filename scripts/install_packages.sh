#!/bin/bash

source "$(pwd)/scripts/install_packages_h.sh"

EXPORTS_FILE=~/.zsh_exports_temp
rm -f "$EXPORTS_FILE"

main_package_manager=$(detect_package_manager)
common_packages=("git" "tmux" "curl" "zsh" "wget" "fzf" "procps" "build-essential")
linux_packages=()
mac_packages=("neovim")

echo "Using package manager: $main_package_manager"

install_packages "$main_package_manager" "${common_packages[@]}"

if [[ "$main_package_manager" == "brew" ]]; then
    install_packages "$main_package_manager" "${mac_packages[@]}"
    nvim_path="$(brew --prefix neovim)/bin/nvim"
else
    install_packages "$main_package_manager" "${linux_packages[@]}"
    
    ARCH=$(uname -m)
    case "$ARCH" in
        aarch64)
            nvim_dir="nvim-linux-arm64"
            ;;
        x86_64)
            nvim_dir="nvim-linux64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    nvim_archive="$nvim_dir.tar.gz"
    curl -LO "https://github.com/neovim/neovim/releases/latest/download/$nvim_archive"
    run_with_priv rm -rf /opt/nvim
    run_with_priv tar -C /opt -xzf "$nvim_archive"

    nvim_path="/opt/$nvim_dir/bin/nvim"
fi

nvim_dir_path=$(dirname "$nvim_path")
echo "export PATH=\"$nvim_dir_path:\$PATH\"" >> "$EXPORTS_FILE"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# zsh-nvm plugin
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm
