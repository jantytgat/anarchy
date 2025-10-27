#!/usr/bin/env bash
source 000_helper.sh

mount_filesystem() {
    ## VARIABLES
    filesystem=$1
    mountpoint=$2
    create_mountpoint=$3

    ## BODY
    print_heading3 "Mount ${filesystem} on ${mountpoint}"
    if $create_mountpoint; then
        print_item "Create mount point ${mountpoint} and mount ${filesystem} on ${mountpoint}"
        mount --mkdir ${filesystem} ${mountpoint}
    else
        print_item "Mount ${filesystem} on ${mountpoint}"
        mount $filesystem $mountpoint
    fi

    read -p "Press enter to continue"
}

generate_fstab() {
    ## VARIABLES
    root_mountpoint=$1

    ## BODY
    print_heading3 "Generating fstab-file for new system"
    print_item "Using ${root_mountpoint} as root for new system"
    genfstab -U $root_mountpoint >> $root_mountpoint/etc/fstab

    read -p "Press enter to continue"
}