#!/usr/bin/env bash

pacman -S --noconfirm git
arch-chroot /mnt mkdir -p /root/anarchy
arch-chroot /mnt git clone git@github.com:jantytgat/anarchy.git /root/anarchy
arch-chroot /mnt bash /root/anarchy/install/install.sh