#!/usr/bin/env bash
passphrase=$1
reflector
pacman-key --init
pacman-key --refresh-keys
pacman -Sy --noconfirm git

git clone https://github.com/jantytgat/anarchy.git
cd anarchy/install
bash install.sh $passphrase