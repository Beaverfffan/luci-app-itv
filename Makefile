#
# Copyright (C) 2026 Beaverfffan
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-itv
PKG_VERSION:=2.0
PKG_RELEASE:=20260915

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Beaverfffan

LUCI_TITLE:=iTV channel source manager (client-side JS)
LUCI_DESCRIPTION:=Serve up to four IPTV channel lists (DIYP / 超级直播 format) over HTTP \
	from the router. Rewritten as a client-side JavaScript view; compatible with \
	OpenWrt 25.x and the apk package format.
LUCI_DEPENDS:=+luci-base
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
