# luci-app-itv — refactored Lua

Manage up to four IPTV channel lists on the router from the LuCI web UI.

This branch keeps the original **Lua CBI** implementation but is a clean
rewrite of its internals. It still needs `luci-compat`, because Lua CBI lives
there on modern OpenWrt.

## What changed vs. 1.2-20231129

| # | Change |
|---|---|
| 1 | The four tab blocks (fourfold copy-paste) became a table-driven loop — adding or removing a slot is now a one-line edit in `CHANNELS` |
| 2 | Removed the author's WeChat handle and promotional copy from the page description |
| 3 | Fixed the original defects: parameter shadowing in `cfgvalue(t, t)` / `write(a, a, t)`, a `local t` assigned twice (making the first line dead), and an unused malformed `html` variable |
| 4 | Writing no longer round-trips through `/tmp` + `cmp -s` + a second write; the comparison happens in Lua. This drops one temp file, one external process and one read-back per save |
| 5 | CRLF → LF normalisation is preserved, as is "only write when the content changed" |

Behaviour is otherwise unchanged and remains compatible with the 1.2 layout.

## Layout

```
Makefile
luasrc/controller/itv.lua      menu registration
luasrc/model/cbi/itv.lua       the form
root/etc/config/itv
root/www/tv1 … tv4             seed templates
```

## Install

Clone the branch straight into your build tree's `package/` directory:

```bash
git clone -b lua https://github.com/Beaverfffan/luci-app-itv.git \
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
