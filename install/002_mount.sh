#!/usr/bin/env bash

mount_filesystem() {
    filesystem=$1
    mountpoint=$2
    create_mountpoint=$3

    if $create_mountpoint; then
        mount --mkdir $filesytem $mountpoint
    else
        mount $filesystem $mountpoint
}

generate_fstab() {
    root_mountpoint=$1
    genfstab -U $root_mountpoint >> $root_mountpoint/etc/fstab
}