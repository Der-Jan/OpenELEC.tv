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

PKG_NAME="systemtap"
PKG_VERSION="2.4"
PKG_REV="1"
PKG_ARCH="any"
PKG_LICENSE="GPL"
PKG_SITE="https://sourceware.org/systemtap/"
PKG_URL="https://github.com/RasPlex/systemtap/archive/release-${PKG_VERSION}.zip"
PKG_DEPENDS="elfutils"
PKG_BUILD_DEPENDS="toolchain elfutils"
PKG_PRIORITY="optional"
PKG_SECTION="devel"
PKG_SHORTDESC="Systemtap profiler"
PKG_LONGDESC="Hardcore profiler"
PKG_IS_ADDON="no"
PKG_AUTORECONF="no"


PKG_IS_ADDON="no"
PKG_AUTORECONF="no"

CC_FOR_BUILD="$HOST_CC"
CFLAGS_FOR_BUILD="$HOST_CFLAGS"

pre_configure_target() {
  # gdb could fail on runtime if build with LTO support
    strip_lto
}

PKG_CONFIGURE_OPTS_TARGET="--host=$TARGET_NAME\
						   --target=$TARGET_NAME\
						   --build=$HOST_NAME\
						   --prefix=$SYSROOT_PREFIX/usr"

