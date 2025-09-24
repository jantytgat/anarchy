#!/usr/bin/env bash
reflector
pacman-key --init
pacman-key --refresh-keys
pacman -Sy --noconfirm --quiet git gum

git clone https://github.com/jantytgat/anarchy.git
