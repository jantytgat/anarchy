#!/usr/bin/env bash

configure_pacman() {
    custom_url=$1

    if [ "$custom_url" = "" ]; then
        cat > /etc/pacman.d/mirrorlist << EOF
##
## Arch Linux repository mirrorlist
## Generated on 2025-09-22
##

# ## Belgium
Server = http://mirror.1ago.be/archlinux/\$repo/os/\$arch
Server = https://mirror.1ago.be/archlinux/\$repo/os/\$arch
Server = http://mirror.jonas-prz.be/\$repo/os/\$arch
Server = https://mirror.jonas-prz.be/\$repo/os/\$arch
Server = http://mirror.tiguinet.net/arch/\$repo/os/\$arch
Server = https://mirror.tiguinet.net/arch/\$repo/os/\$arch

# ##Netherlands
Server = http://ams.nl.mirrors.bjg.at/arch/\$repo/os/\$arch
Server = https://ams.nl.mirrors.bjg.at/arch/\$repo/os/\$arch
Server = http://mirror.bouwhuis.network/archlinux/\$repo/os/\$arch
Server = https://mirror.bouwhuis.network/archlinux/\$repo/os/\$arch
Server = http://mirror.nl.cdn-perfprod.com/archlinux/\$repo/os/\$arch
Server = https://mirror.nl.cdn-perfprod.com/archlinux/\$repo/os/\$arch
Server = http://nl.mirrors.cicku.me/archlinux/\$repo/os/\$arch
Server = https://nl.mirrors.cicku.me/archlinux/\$repo/os/\$arch
Server = http://mirror.cj2.nl/archlinux/\$repo/os/\$arch
Server = https://mirror.cj2.nl/archlinux/\$repo/os/\$arch
Server = http://mirrors.evoluso.com/archlinux/\$repo/os/\$arch
Server = http://nl.mirror.flokinet.net/archlinux/\$repo/os/\$arch
Server = https://nl.mirror.flokinet.net/archlinux/\$repo/os/\$arch
Server = http://mirror.i3d.net/pub/archlinux/\$repo/os/\$arch
Server = https://mirror.i3d.net/pub/archlinux/\$repo/os/\$arch
Server = https://mirror.iusearchbtw.nl/\$repo/os/\$arch
Server = http://mirror.koddos.net/archlinux/\$repo/os/\$arch
Server = https://mirror.koddos.net/archlinux/\$repo/os/\$arch
Server = http://arch.mirrors.lavatech.top/\$repo/os/\$arch
Server = https://arch.mirrors.lavatech.top/\$repo/os/\$arch
Server = http://mirror.ams1.nl.leaseweb.net/archlinux/\$repo/os/\$arch
Server = https://mirror.ams1.nl.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://archlinux.mirror.liteserver.nl/\$repo/os/\$arch
Server = https://archlinux.mirror.liteserver.nl/\$repo/os/\$arch
Server = http://mirror.lyrahosting.com/archlinux/\$repo/os/\$arch
Server = https://mirror.lyrahosting.com/archlinux/\$repo/os/\$arch
Server = http://mirror.mijn.host/archlinux/\$repo/os/\$arch
Server = https://mirror.mijn.host/archlinux/\$repo/os/\$arch
Server = https://nl.arch.niranjan.co/\$repo/os/\$arch
Server = http://ftp.nluug.nl/os/Linux/distr/archlinux/\$repo/os/\$arch
Server = http://mirror.serverion.com/archlinux/\$repo/os/\$arch
Server = https://mirror.serverion.com/archlinux/\$repo/os/\$arch
Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch
Server = http://archlinux.mirror.wearetriple.com/\$repo/os/\$arch
Server = https://archlinux.mirror.wearetriple.com/\$repo/os/\$arch
Server = http://mirrors.xtom.nl/archlinux/\$repo/os/\$arch
Server = https://mirrors.xtom.nl/archlinux/\$repo/os/\$arch
EOF

    else
        cat > /etc/pacman.d/mirrorlist << EOF
##
## Arch Linux repository mirrorlist
## Generated on 2025-09-22
##

Server = $custom_url\$repo/os/\$arch

# ## Belgium
# Server = http://mirror.1ago.be/archlinux/\$repo/os/\$arch
# Server = https://mirror.1ago.be/archlinux/\$repo/os/\$arch
# Server = http://mirror.jonas-prz.be/\$repo/os/\$arch
# Server = https://mirror.jonas-prz.be/\$repo/os/\$arch
# Server = http://mirror.tiguinet.net/arch/\$repo/os/\$arch
# Server = https://mirror.tiguinet.net/arch/\$repo/os/\$arch

# ## Netherlands
# Server = http://ams.nl.mirrors.bjg.at/arch/\$repo/os/\$arch
# Server = https://ams.nl.mirrors.bjg.at/arch/\$repo/os/\$arch
# Server = http://mirror.bouwhuis.network/archlinux/\$repo/os/\$arch
# Server = https://mirror.bouwhuis.network/archlinux/\$repo/os/\$arch
# Server = http://mirror.nl.cdn-perfprod.com/archlinux/\$repo/os/\$arch
# Server = https://mirror.nl.cdn-perfprod.com/archlinux/\$repo/os/\$arch
# Server = http://nl.mirrors.cicku.me/archlinux/\$repo/os/\$arch
# Server = https://nl.mirrors.cicku.me/archlinux/\$repo/os/\$arch
# Server = http://mirror.cj2.nl/archlinux/\$repo/os/\$arch
# Server = https://mirror.cj2.nl/archlinux/\$repo/os/\$arch
# Server = http://mirrors.evoluso.com/archlinux/\$repo/os/\$arch
# Server = http://nl.mirror.flokinet.net/archlinux/\$repo/os/\$arch
# Server = https://nl.mirror.flokinet.net/archlinux/\$repo/os/\$arch
# Server = http://mirror.i3d.net/pub/archlinux/\$repo/os/\$arch
# Server = https://mirror.i3d.net/pub/archlinux/\$repo/os/\$arch
# Server = https://mirror.iusearchbtw.nl/\$repo/os/\$arch
# Server = http://mirror.koddos.net/archlinux/\$repo/os/\$arch
# Server = https://mirror.koddos.net/archlinux/\$repo/os/\$arch
# Server = http://arch.mirrors.lavatech.top/\$repo/os/\$arch
# Server = https://arch.mirrors.lavatech.top/\$repo/os/\$arch
# Server = http://mirror.ams1.nl.leaseweb.net/archlinux/\$repo/os/\$arch
# Server = https://mirror.ams1.nl.leaseweb.net/archlinux/\$repo/os/\$arch
# Server = http://archlinux.mirror.liteserver.nl/\$repo/os/\$arch
# Server = https://archlinux.mirror.liteserver.nl/\$repo/os/\$arch
# Server = http://mirror.lyrahosting.com/archlinux/\$repo/os/\$arch
# Server = https://mirror.lyrahosting.com/archlinux/\$repo/os/\$arch
# Server = http://mirror.mijn.host/archlinux/\$repo/os/\$arch
# Server = https://mirror.mijn.host/archlinux/\$repo/os/\$arch
# Server = https://nl.arch.niranjan.co/\$repo/os/\$arch
# Server = http://ftp.nluug.nl/os/Linux/distr/archlinux/\$repo/os/\$arch
# Server = http://mirror.serverion.com/archlinux/\$repo/os/\$arch
# Server = https://mirror.serverion.com/archlinux/\$repo/os/\$arch
# Server = http://ftp.snt.utwente.nl/pub/os/linux/archlinux/\$repo/os/\$arch
# Server = http://archlinux.mirror.wearetriple.com/\$repo/os/\$arch
# Server = https://archlinux.mirror.wearetriple.com/\$repo/os/\$arch
# Server = http://mirrors.xtom.nl/archlinux/\$repo/os/\$arch
# Server = https://mirrors.xtom.nl/archlinux/\$repo/os/\$arch
EOF
    fi
}