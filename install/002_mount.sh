#!/usr/bin/env bash

mount_filesystem() {
    ## VARIABLES
    filesystem=$1
    mountpoint=$2
    create_mountpoint=$3

    ## BODY
    print_heading3 "Mount ${filesystem}"
    if $create_mountpoint; then
        print_item "Create mount point ${mountpoint} and mount ${filesystem}"
        mount --mkdir $filesytem $mountpoint
    else
        print_item "Mount ${filesystem}"
        mount $filesystem $mountpoint
    fi
}

generate_fstab() {
    ## VARIABLES
    root_mountpoint=$1

    ## BODY
    print_heading3 "Generating fstab-file for new system"
    print_item "Using ${root_mountpoint} as root for new system"
    genfstab -U $root_mountpoint >> $root_mountpoint/etc/fstab
}