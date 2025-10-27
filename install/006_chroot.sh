#!/usr/bin/env bash
source 000_helper.sh


set_timezone() {
    print_item "Set timezone"
    arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Brussels /etc/localtime
    arch-chroot /mnt hwclock --systohc
}

set_locale() {
    print_item "Generating locales"
    arch-chroot /mnt locale-gen

    print_item "Configure locale"
    cat > /mnt/etc/locale.conf << EOF
LANG=en_US.UTF-8
EOF
}

set_hostname() {
    hostname=$1
    print_item "Set hostname"
    echo ${hostname} > /mnt/etc/hostname
}

set_authorized_keys_for_root() {
    print_item "Configure authorized_keys for root"
    curl https://github.com/jantytgat.keys >> /mnt/root/.ssh/authorized_keys
}

configure_crypttab() {
    data_partition=$1
    data_keyfile=$2

    print_item "Configure /etc/crypttab for data partition"
    cat > /mnt/etc/crypttab << EOF
data PARTUUID=$(lsblk -dno PARTUUID ${data_partition}) ${data_keyfile}
EOF
}

configure_systemd_boot() {
    root_partition=$1
    print_item "Configure systemd-boot"
    arch-chroot /mnt bootctl install

    print_item "Configure boot loader"
    cat > /mnt/boot/loader/loader.conf << EOF
default  arch.conf
timeout  4
console-mode max
editor   no
EOF

    print_item "Configure main boot entry"
    cat > /mnt/boot/loader/entries/arch.conf << EOF
title   Arch Linux
linux   /vmlinuz-linux
initrd  /initramfs-linux.img
options ip=:::::eth0:dhcp cryptdevice=PARTUUID=$(lsblk -dno PARTUUID ${root_partition}):root root=/dev/mapper/root zswap.enabled=0 rw rootfstype=ext4
EOF

    print_item "Configure fallback boot entry"
    cat > /mnt/boot/loader/entries/arch-fallback.conf << EOF
title   Arch Linux (fallback initramfs)
linux   /vmlinuz-linux
initrd  /initramfs-linux-fallback.img
options ip=:::::eth0:dhcp cryptdevice=PARTUUID=$(lsblk -dno PARTUUID ${root_partition}):root root=/dev/mapper/root zswap.enabled=0 rw rootfstype=ext4
EOF
}