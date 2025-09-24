#!/usr/bin/env bash

create_boot_filesystem() {
    disk=$1
    # Create filesystem for EFI/Boot
    # echo "Create filesystem for boot partition"
    mkfs.fat -F 32 -n EFI $disk'1'
}

create_luks_data_filesystem() {
    data_partition=$1
    data_name=data
    data_mapper=/dev/mapper/$data_name
    data_keyfile=/etc/cryptsetup-keys.d/data.key

    # Create random key for data partition
    dd bs=512 count=4 if=/dev/random iflag=fullblock | install -m 0600 /dev/stdin $data_keyfile

    # Create encrypted partition for /data
    echo "Creating encrypted partition for $data_partition on $data_name"
    cryptsetup luksFormat -q --key-file=$data_keyfile $data_partition
    cryptsetup open --key-file=$data_keyfile $data_partition $data_name
    echo "Formatting xfs filesystem on $data_mapper"
    mkfs.xfs -L DATA $data_mapper
}

create_luks_root_filesystem() {
    root_passphrase=$1
    root_partition=$2
    root_name=root
    root_mapper=/dev/mapper/$root_name
    root_keyfile=/root/key.txt

    # TODO - REPLACE WITH INPUT FROM STDIN
    # Flag -n is required to remove the newline in the key file
    echo -n $root_passphrase > $root_keyfile

    # Create encrypted partition for /
    #echo "Creating encrypted partition for $root_name on $root_partition"
    cryptsetup luksFormat -q --key-file=$root_keyfile $root_partition
    cryptsetup open --key-file=$root_keyfile $root_partition $root_name
    #echo "Formatting ext4 filesystem on $root_mapper"
    mkfs.ext4 -L ROOT $root_mapper

}

has_data_disk() {
    disk=$1
    if test -f $disk; then
        return 0
    else
        return 1
    fi
}

is_uefi_boot_mode() {
    # Check boot mode
    boot_mode=$(cat /sys/firmware/efi/fw_platform_size)
    if [[ "$boot_mode" = 64 ]]; then
        return 0
    else
        return 1
    fi
}

partition_primary_disk() {
    disk=$1

    # echo "Wiping current filesystem on $disk"
    wipefs -a $disk

    # echo "Partitioning $disk"
    parted -s $disk mklabel gpt
    parted -s --align=optimal $disk mkpart EFI fat32 1MiB 1025MiB
    parted -s $disk set 1 esp on
    parted -s --align=optimal $disk mkpart "root" ext4 1025MiB 100%
    #parted -s $disk print
    #sleep 5
}

partition_data_disk() {
    disk=$1

    #echo "Wiping current filesystem on $disk"
    wipefs -a $disk
    # echo "Partitioning $disk"
    parted -s $disk mklabel gpt
    parted -s $disk unit mib mkpart primary 0% 100%
    #parted -s $disk print
    #sleep 5
}

