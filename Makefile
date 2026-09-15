#
# Copyright (C) 2023 iamyaiok
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=iTV channel for OpenWRT
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all
PKG_VERSION:=1.2
PKG_RELEASE:=20231129

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
