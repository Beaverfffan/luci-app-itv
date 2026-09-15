# luci-app-itv — client-side JS

Manage up to four IPTV channel lists on the router from the LuCI web UI.

This branch is a **from-scratch rewrite** for the modern LuCI architecture:
client-side JavaScript view, `menu.d` / `acl.d` JSON, and **no `luci-compat`
dependency**. It targets OpenWrt 25.x and the **apk** package format, while
remaining buildable on 24.10 (ipk).

## Why a rewrite

The original is a Lua CBI app from 2023. Modern LuCI moved to client-side JS +
ucode, and Lua CBI now needs the `luci-compat` shim. This branch drops that shim
entirely and talks to the filesystem through LuCI's own `fs` module.

## Layout

```
Makefile
htdocs/luci-static/resources/view/itv/tv.js     the view
root/usr/share/luci/menu.d/luci-app-itv.json    menu entry
root/usr/share/rpcd/acl.d/luci-app-itv.json     read/write ACL for /www/tvN
root/www/tv1 … tv4                              seed templates
root/etc/config/itv                             kept for upgrade compatibility
```

Writes go through the `file` ubus object, gated by the ACL above. The view only
issues a write when the content actually changed, so saving an untouched box
never touches flash.

## Requirements

* OpenWrt 24.10+ / 25.x with LuCI
* `luci-base` (pulled in automatically)
* No `luci-compat`, no Lua CBI

## Install

Clone the branch straight into your build tree's `package/` directory:

```bash
git clone -b main https://github.com/Beaverfffan/luci-app-itv.git \
    package/luci-app-itv
```

Then enable and build:

```bash
make menuconfig          # LuCI -> Applications -> luci-app-itv
make package/luci-app-itv/compile V=s
```

The resulting package lands in `bin/packages/<arch>/luci/`. On OpenWrt 24.10+
and 25.x the build system emits **apk** packages; on older trees it emits ipk.
The same source produces either — `luci.mk` picks the format.

## How it works

Each slot is backed by a plain file on the router:

| Slot | Backing file | Served at |
|---|---|---|
| TV1 | `/www/tv1` | `http://<router>/tv1` |
| TV2 | `/www/tv2` | `http://<router>/tv2` |
| TV3 | `/www/tv3` | `http://<router>/tv3` |
| TV4 | `/www/tv4` | `http://<router>/tv4` |

Point DIYP / 超级直播 (or any player that can fetch a remote list) at those URLs.
A slot only appears in the UI while its file exists — delete `/www/tvN` to retire
that slot.

## Provenance / licensing

Original author: **iamyaiok** — WeChat ID `iamyaiok`, the handle embedded in the
original LuCI page description.

This repository was reconstructed from a binary-only package,
`luci-app-itv_1.2-20231129_all.ipk`, whose `control` metadata carried **no license
field**. The licence status is therefore **unknown**: no licence is granted here,
and the original author's terms, whatever they may be, continue to apply.

* The **original** branch is a byte-faithful dump and carries whatever rights the
  original author granted — which is to say, unclear. Treat it as a reference copy.
* The **lua** branch is a derivative refactor of that code, so the same caveat applies.
* The **js** branch is an independent client-side reimplementation of the same idea.
  It shares no code with the original.

If you are the original author and want any branch taken down or re-licensed,
open an issue.
