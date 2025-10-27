#!/usr/bin/env bash
source 000_helper.sh
source 001_partition.sh
source 002_mount.sh
source 003_configure_pacman.sh
source 004_pacstrap.sh
source 005_ssh.sh
source 006_chroot.sh

main() {
    ### INPUT

    # $1 = hostname
    # $2 = root passphrase
    # $3 = custom pacman url
    # $4 = custom url is pacoloco proxy (true | false)

    ### VARIABLES
    hostname=$1
    primary_disk=/dev/sda
    data_disk=/dev/sdb
    
    boot_partition=/dev/sda1
    boot_mountpoint=/mnt/boot
    boot_mountpoint_create=true

    root_passphrase=$2
    root_partition=/dev/sda2
    root_mapper=/dev/mapper/root
    root_mountpoint=/mnt
    root_mountpoint_create=false

    data_disk_found=false
    data_partition=/dev/sdb1
    data_mapper=/dev/mapper/data
    data_mountpoint=/mnt/data
    data_mountpoint_create=true
    data_keyfile=

    custom_url=$3
    is_pacoloco=$4

    ### MAIN BODY    
    print_start

    if  ! is_uefi_boot_mode; then
        echo "System not booted in UEFI mode"
        exit 1
    fi

    if [[ "$root_passphrase" = "" ]]; then
        echo "Root passphrase is empty"
    fi

    if [[ "$is_pacoloco" = "" ]]; then
        is_pacoloco=false
    fi

    print_heading1 "Setting up environment"
    # List available keymaps
    #localectl list-keymaps
    # Set keyboard layout
    loadkeys en

    # TODO vconsole?

    print_heading1 "Partitioning disks"
    print_heading2 "Partitioning primary disk ${primary_disk}"
    partition_primary_disk $primary_disk

    create_boot_filesystem $primary_disk
    create_luks_root_filesystem $root_passphrase $root_partition "ext4"

    print_heading2 "Mount primary filesystems"
    # First mount root partition
    mount_filesystem $root_mapper $root_mountpoint $root_mountpoint_create
    mount_filesystem $boot_partition $boot_mountpoint $boot_mountpoint_create

    if has_data_disk $data_disk; then
        print_heading2 "Partitioning data disk ${data_disk}"
        data_disk_found=true
        partition_data_disk $data_disk
        create_luks_data_filesystem $data_partition "xfs"

        print_heading2 "Mount data filesystem"
        mount_filesystem $data_mapper $data_mountpoint $data_mountpoint_create
        copy_luks_keyfile $data_keyfile
    fi

    print_heading1 "Install base system"
    print_heading2 "Configuring installer"
    if [ "$custom_url" = "" ]; then
        configure_pacman
    elif $is_pacoloco; then
        if [[ "$custom_url" == */repo/archlinux ]]; then
            configure_pacman "${custom_url}/repo/archlinux"
        fi
    else
        configure_pacman $custom_url
    fi

    print_heading2 "Installing packages"
    install_base_system $root_mountpoint

    print_heading2 "Prepare system mounts"
    generate_fstab $root_mountpoint

    print_heading1 "Configuring target environment"
    print_heading2 "Configuring SSH"
    copy_ssh_hostkeys

    print_heading2 "Create files on chroot filesystem"
    set_timezone
    set_locale
    set_hostname $hostname
    set_authorized_keys_for_root

    if has_data_disk $data_disk; then
        configure_crypttab $data_partition $data_keyfile
    fi

    configure_systemd_boot $root_partition
}

main "$@"