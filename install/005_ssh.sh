#!/usr/bin/env bash
source 000_helper.sh

copy_ssh_hostkeys() {
    print_item "Copy installer host keys from /etc/ssh tp /mnt/etc/ssh"
    cp /etc/ssh/ssh_host* /mnt/etc/ssh/.
}