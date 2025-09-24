#!/usr/bin/env bash
pacman-key --init
reflector
pacman -Sy --noconfirm git
git clone git@github.com:jantytgat/anarchy.git
bash anarchy/install/install.sh