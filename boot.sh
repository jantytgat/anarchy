#!/usr/bin/env bash
passphrase=$1
reflector
pacman-key --init
pacman-key --refresh-keys
pacman -Sy --noconfirm --quiet git gum
sleep 5

print_title
git clone https://github.com/jantytgat/anarchy.git
cd anarchy/install
bash install.sh $passphrase