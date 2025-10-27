#!/usr/bin/env bash
source 000_helper.sh

install_base_system() {
    ## VARIABLES
    chroot_mountpoint=$1

    ## BODY
    print_heading3 "Installing packages to ${chroot_mountpoint}"
    print_item "Running pacstrap"
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

    read -p "Press enter to continue"
}