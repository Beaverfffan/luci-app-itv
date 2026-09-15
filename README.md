# luci-app-itv — original unpacked

A **byte-faithful dump** of `luci-app-itv_1.2-20231129_all.ipk`, rearranged back
into the source layout LuCI's `luci.mk` expects.

## How it was reconstructed

The ipk is a **tar.gz** (not the older `ar` format) containing
`debian-binary`, `control.tar.gz` and `data.tar.gz`. The `data` payload was
unpacked and its paths mapped back to source locations:

| In the ipk | In the source tree |
|---|---|
| `/usr/lib/lua/luci/controller/itv.lua` | `luasrc/controller/itv.lua` |
| `/usr/lib/lua/luci/model/cbi/itv.lua` | `luasrc/model/cbi/itv.lua` |
| `/etc/config/itv` | `root/etc/config/itv` |
| `/www/tv1` … `/www/tv4` | `root/www/tv1` … `tv4` |

Every one of those files is **byte-identical** to the ipk payload.

## What is *not* original

* **`Makefile`** — the ipk does not contain one. It was rebuilt from the
  `control` metadata (`Version: 1.2-20231129`, `Description: iTV channel for
  OpenWRT`). `LUCI_DEPENDS:=+luci-compat` is an inference: the code uses classic
  Lua CBI, which modern LuCI ships in `luci-compat`.
* **`postinst` / `prerm`** — deliberately omitted; OpenWrt generates them from
  `default_postinst` / `default_prerm`.

## Caveat: the Lua is minified

`luci.mk` defaults to `LUCI_MINIFY_LUA=1`, so the Lua shipped inside the ipk is
**minifier output** — single-letter locals, no indentation, several statements
per line. The original pre-minify source is **not recoverable**; what you get here
is the exact minified text, not the author's readable source.

For a readable version see the `lua` branch, which is a refactor, or the
`reformatted` copy that shipped with the local restoration work.

## Install

Clone the branch straight into your build tree's `package/` directory:

```bash
git clone -b original https://github.com/Beaverfffan/luci-app-itv.git \
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
