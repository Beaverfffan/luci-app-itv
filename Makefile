#
# Copyright (C) 2026 Beaverfffan
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-itv
PKG_VERSION:=1.3
PKG_RELEASE:=20260915

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Beaverfffan

LUCI_TITLE:=iTV channel source manager (refactored Lua / CBI)
LUCI_DESCRIPTION:=Serve up to four IPTV channel lists (DIYP / 超级直播 format) over HTTP \
	from the router. Refactored Lua CBI implementation of luci-app-itv 1.2.
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
