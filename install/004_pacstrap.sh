#!/usr/bin/env bash

install_base_system() {
    chroot_mountpoint=$1
    pacstrap -K $chroot_mountpoint \
    base \
    ca-certificates \
    ca-certificates-mozilla \
    ca-certificates-utils \
    cloud-init \
    curl \
    dhclient \
    git \
    iproute2 \
    iputils \
    linux \
    linux-firmware \
    man-db \
    man-pages \
    mkinitcpio-dropbear \
    mkinitcpio-netconf \
    mkinitcpio-utils \
    openssh \
    nano \
    qemu-guest-agent \
    sudo \
    texinfo \
    tmux \
    wget
}