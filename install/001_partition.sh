#!/usr/bin/env bash
source 000_helper.sh

create_boot_filesystem() {
    ## VARIABLES
    disk=$1

    ## BODY
    print_heading3 "Create boot filesystem on ${disk}"
    # Create filesystem for EFI/Boot
    print_item "Formatting filesystem for boot partition"
    mkfs.fat -F 32 -n EFI $disk'1'
}

create_luks_data_filesystem() {
    ## VARIABLES
    data_partition=$1
    data_fstype=$2
    data_name=data
    data_mapper=/dev/mapper/$data_name
    data_keyfile=/etc/cryptsetup-keys.d/data.key

    ## BODY
    print_heading3 "Create encrypted filesystem on ${data_partition}"

    print_item "Create random key for data partition"
    dd bs=512 count=4 if=/dev/random iflag=fullblock | install -m 0600 /dev/stdin $data_keyfile

    # Create encrypted partition for /data
    print_item "Creating encrypted partition for $data_name on $data_partition"
    cryptsetup luksFormat -q --key-file=$data_keyfile $data_partition
    cryptsetup open --key-file=$data_keyfile $data_partition $data_name

    print_item "Formatting ${data_fstype} filesystem on $data_mapper"
    if [[ "$data_fstype" = "xfs" ]]; then
        mkfs.xfs -L DATA $data_mapper
    else
        mkfs.ext4 -L DATA $data_mapper
    fi
}

create_luks_root_filesystem() {
    ## VARIABLES
    root_passphrase=$1
    root_partition=$2
    root_fstype=$3
    root_name=root
    root_mapper=/dev/mapper/$root_name
    root_keyfile=/root/key.txt

    ## BODY
    print_heading3 "Create encrypted filesystem on ${root_partition}"

    # TODO - REPLACE WITH INPUT FROM STDIN
    # Flag -n is required to remove the newline in the key file
    echo -n $root_passphrase > $root_keyfile

    # Create encrypted partition for /
    print_item "Creating encrypted partition for $root_name on $root_partition"
    cryptsetup luksFormat -q --key-file=$root_keyfile $root_partition
    cryptsetup open --key-file=$root_keyfile $root_partition $root_name
    
    print_item "Formatting ${root_fstype} filesystem on $root_mapper"
    if [[ "$root_fstype" = "xfs" ]]; then
        mkfs.xfs -L ROOT $root_mapper
    else
        mkfs.ext4 -L ROOT $root_mapper
    fi
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

