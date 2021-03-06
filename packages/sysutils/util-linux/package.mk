################################################################################
#      This file is part of OpenELEC - http://www.openelec.tv
#      Copyright (C) 2009-2012 Stephan Raue (stephan@openelec.tv)
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with OpenELEC.tv; see the file COPYING.  If not, write to
#  the Free Software Foundation, 51 Franklin Street, Suite 500, Boston, MA 02110, USA.
#  http://www.gnu.org/copyleft/gpl.html
################################################################################

PKG_NAME="util-linux"
PKG_VERSION="2.23.2"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_URL="http://www.kernel.org/pub/linux/utils/util-linux/v2.23/$PKG_NAME-$PKG_VERSION.tar.xz"
PKG_DEPENDS=""
PKG_BUILD_DEPENDS_TARGET="toolchain"
PKG_PRIORITY="optional"
PKG_SECTION="system"
PKG_SHORTDESC="util-linux: Miscellaneous system utilities for Linux"
PKG_LONGDESC="The util-linux package contains a large variety of low-level system utilities that are necessary for a Linux system to function. Among many features, Util-linux contains the fdisk configuration tool and the login program."

PKG_IS_ADDON="no"
PKG_AUTORECONF="yes"

PKG_CONFIGURE_OPTS_TARGET="--disable-gtk-doc \
                           --disable-nls \
                           --disable-rpath \
                           --enable-tls \
                           --enable-libuuid \
                           --enable-libblkid \
                           --enable-libmount \
                           --disable-deprecated-mount \
                           --disable-mount \
                           --enable-fsck \
                           --disable-partx \
                           --enable-uuidd \
                           --disable-mountpoint \
                           --disable-fallocate \
                           --disable-unshare \
                           --disable-arch \
                           --disable-ddate \
                           --disable-eject \
                           --disable-agetty \
                           --disable-cramfs \
                           --disable-switch-root \
                           --disable-pivot-root \
                           --disable-elvtune \
                           --disable-kill \
                           --disable-last \
                           --disable-utmpdump \
                           --disable-line \
                           --disable-mesg \
                           --disable-raw \
                           --disable-rename \
                           --disable-reset \
                           --disable-vipw \
                           --disable-newgrp \
                           --disable-chfn-chsh \
                           --enable-chsh-only-listed \
                           --disable-login \
                           --disable-login-chown-vcs \
                           --disable-login-stat-mail \
                           --disable-sulogin \
                           --disable-su \
                           --disable-runuser \
                           --disable-ul \
                           --disable-more \
                           --disable-pg \
                           --disable-setterm \
                           --disable-schedutils \
                           --disable-wall \
                           --disable-write \
                           --disable-chkdupexe \
                           --disable-socket-activation \
                           --disable-pg-bell \
                           --disable-require-password \
                           --disable-use-tty-group \
                           --disable-makeinstall-chown \
                           --disable-makeinstall-setuid \
                           --with-gnu-ld \
                           --without-selinux \
                           --without-audit \
                           --without-udev \
                           --without-ncurses \
                           --without-slang \
                           --without-utempter \
                           --without-systemdsystemunitdir"

post_makeinstall_target() {
  rm -rf $INSTALL/usr/bin
  rm -rf $INSTALL/usr/sbin
  rm -rf $INSTALL/usr/share

  mkdir -p $INSTALL/usr/sbin
    cp fstrim $INSTALL/usr/sbin
    cp .libs/blkid $INSTALL/usr/sbin
    cp .libs/fsck $INSTALL/usr/sbin

  if [ "$SWAP_SUPPORT" = "yes" ]; then
    mkdir -p $INSTALL/usr/sbin
      cp .libs/swapon $INSTALL/usr/sbin
      cp .libs/swapoff $INSTALL/usr/sbin

    mkdir -p $INSTALL/etc/init.d
      cp $PKG_DIR/scripts/32_swapfile $INSTALL/etc/init.d

    mkdir -p $INSTALL/etc
      cat $PKG_DIR/config/swap.conf | sed -e "s,@SWAPFILESIZE@,$SWAPFILESIZE,g" > $INSTALL/etc/swap.conf
  fi
}
