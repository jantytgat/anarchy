#!/usr/bin/env bash
pacman-key --init
pacman -Syu --noconfirm
pacman-key --refresh-keys

reflector
pacman -Sy --noconfirm ca-certificates
pacman -Sy --noconfirm git
git clone https://github.com/jantytgat/anarchy.git
bash anarchy/install/install.sh