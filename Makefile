#
# Refactored Lua CBI implementation of luci-app-itv.
#
# The original luci-app-itv 1.2 package carried no licence metadata, so the
# licence status of this derivative work is UNKNOWN -- no licence is granted
# here and the original author's terms, whatever they may be, continue to
# apply.  Deliberately no PKG_LICENSE: see README.md "Provenance / licensing".
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-itv
PKG_VERSION:=1.3
PKG_RELEASE:=20260915

PKG_MAINTAINER:=Beaverfffan

LUCI_TITLE:=iTV channel source manager (refactored Lua / CBI)
LUCI_DESCRIPTION:=Serve up to four IPTV channel lists (DIYP / 超级直播 format) over HTTP \
	from the router. Refactored Lua CBI implementation of luci-app-itv 1.2.
LUCI_DEPENDS:=+luci-compat
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
