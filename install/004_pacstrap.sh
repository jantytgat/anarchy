#!/usr/bin/env bash
source 000_helper.sh

install_base_system() {
    ## VARIABLES
    chroot_mountpoint=$1

    ## BODY
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
    sudo \
    texinfo \
    tmux \
    wget
}

install_as_vm_qemu() {
    ## VARIABLES
    chroot_mountpoint=$1

    ## BODY
    print_item "Running pacstrap for QEMU virtual machine"
    pacstrap -K $chroot_mountpoint \
    qemu-guest-agent
}

install_as_vm_vmware() {
    ## VARIABLES
    chroot_mountpoint=$1

    ## BODY
    print_item "Running pacstrap for VMware virtual machine"
    pacstrap -K $chroot_mountpoint \
    open-vm-tools
}