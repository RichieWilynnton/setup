#!/bin/bash

source "$(pwd)/scripts/install_packages.sh"
source "$(pwd)/scripts/move_configs.sh"
nvim --headless "+Lazy! sync" +qa
