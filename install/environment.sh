#!/usr/bin/env bash

### INPUT
# $1 = hostname
# $2 = root passphrase
# $3 = custom pacman url
# $4 = custom url is pacoloco proxy (true | false)
### VARIABLES
# hostname=$1
primary_disk=/dev/sda
data_disk=/dev/sdb
boot_partition=/dev/sda1
boot_mountpoint=/mnt/boot
boot_mountpoint_create=true
# root_passphrase=$2
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
# custom_url=$3
# is_pacoloco=$4