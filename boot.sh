#!/usr/bin/env bash

pacman -Sy --noconfirm git
git clone git@github.com:jantytgat/anarchy.git
bash anarchy/install/install.sh