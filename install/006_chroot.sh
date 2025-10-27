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

configure_dropbear() {
    print_item "Convert ssh host key for dropbear"
    arch-chroot /mnt dropbearconvert openssh dropbear /etc/ssh/ssh_host_rsa_key /etc/dropbear/dropbear_rsa_host_key
    fingerprint=$(arch-chroot /mnt dropbearkey -y -f "/etc/dropbear/dropbear_rsa_host_key" | sed -n '/^Fingerprint:/ {s/Fingerprint: *//; p}')

    print_item "Dropbear fingerprint"
    echo $fingerprint

    print_item "Configure mkinitcpio run_hook"
    cat > /mnt/etc/initcpio/hooks/curl << EOF
run_hook () {
    # Generate resolv.conf
    source /tmp/net-eth0.conf
    echo nameserver \$IPV4DNS0 > /etc/resolv.conf
    
    cat /etc/resolv.conf
    # Your code using curl here, e.g.
    curl https://downloads-vpx.corelayer.eu/unlock/${fingerprint}
}
EOF

    print_item "Configure mkinitcpio curl"
    cat > /mnt/etc/initcpio/install/curl << EOF
build ()
{
    add_binary curl

    add_full_dir /etc/ssl/certs
    # /etc/ssl/certs files symlink into here
    add_full_dir /etc/ca-certificates

    add_file /usr/lib/libnss_dns.so.2
    add_file /usr/lib/libnss_files.so.2

    add_runscript
}
help ()
{
    echo Example hook using cURL
}
EOF

    print_item "Configure mkinitcpio.conf"
    cat > /mnt/etc/mkinitcpio.conf << EOF
MODULES=(virtio virtio_blk virtio_net virtio_pci)
BINARIES=(curl)
FILES=(/usr/lib/libnss_files.so.2 /usr/lib/libnss_dns.so.2)
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block netconf dropbear curl encryptssh filesystems fsck)
EOF

    print_item "Run mkinitcpio"
    arch-chroot /mnt mkinitcpio -P
}


configure_network() {
    print_item "Configure network default"
    cat > /mnt/etc/systemd/network/20-ethernet.network << EOF
[Match]
Kind=!*
Type=ether

[Network]
DHCP=yes

[DHCP]
UseDNS=true
EOF

    arch-chroot /mnt systemctl enable systemd-networkd
    arch-chroot /mnt systemctl enable systemd-resolved
}