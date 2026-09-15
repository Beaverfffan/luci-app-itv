--[[
  luci-app-itv  ---  CBI 模型（重构版）

  相对原版（1.2-20231129）的改动：
    1. 四个标签页由「四份复制粘贴」改为表驱动，新增/删除频道只需改 CHANNELS
    2. 去掉描述文案里内嵌的作者微信号与推广语
    3. 修掉下列原版缺陷：
         · conf.cfgvalue = function(t, t)      -- 形参重名，第二个遮蔽第一个
         · conf.write    = function(a, a, t)   -- 同上
         · local t 连续赋值两次，第一行形同废码
         · html 变量为死代码：赋值后从未被使用，且标签本身残缺（href 后缺 '>'）
    4. 写盘不再「写 /tmp → cmp -s → 再写回」，直接在 Lua 里比较字符串，
       省掉一次临时文件写、一次外部进程和一次读回
    5. 统一换行 CRLF → LF 的行为保持不变

  行为兼容性：与 1.2 版一致 —— 每个标签页仅当 /www/tvN 存在时才出现，
  文本框内容即 /www/tvN 的内容，播放器可从 http://路由器IP/tvN 拉取。
--]]

local fs = require "nixio.fs"

-- 预留给后续按需扩展（原版为 UCI 而设，本版暂未使用字段）
local uci = require("luci.model.uci").cursor()

local CHANNELS = {
	{ id = 1, icon = "📕", hint = "频道源节目单地址" },
	{ id = 2, icon = "📗", hint = "节目单挂载地址" },
	{ id = 3, icon = "📘", hint = "节目单挂载地址" },
	{ id = 4, icon = "📙", hint = "节目单挂载地址" },
}

local function access_url(id)
	return string.format("http://路由器主机名.lan/tv%d 或 http://路由器IP/tv%d", id, id)
end

local m = Map("itv",
	translate("📺iTV频道源管理"),
	translate("配合电视直播软件（DIYP、超级直播等），路由器挂载频道源节目单。"))
m.apply_on_parse = true

local s = m:section(TypedSection, "itv")
s.anonymous = true

for _, ch in ipairs(CHANNELS) do
	local path = string.format("/www/tv%d", ch.id)

	if fs.access(path) then
		s:tab(string.format("TV%d", ch.id),
			translate(ch.icon .. string.format("TV%d", ch.id)),
			translate(string.format(
				"<font color=\"yellow\"><strong>%s为 %s</strong></font>",
				ch.hint, access_url(ch.id))))

		local conf = s:taboption(string.format("TV%d", ch.id), Value,
			string.format("TV%d", ch.id), nil,
			translate("<font color=\"yellow\"><strong>" ..
				"分类及直播源地址格式，一定要按直播软件要求写，否则无效。</strong></font>"))
		conf.template = "cbi/tvalue"
		conf.rows     = 20
		conf.wrap     = "off"

		conf.cfgvalue = function(self, section)
			return fs.readfile(path) or ""
		end

		conf.write = function(self, section, value)
			if value == nil then
				return
			end

			value = value:gsub("\r\n?", "\n")

			-- 内容没变就不碰 flash
			if fs.readfile(path) ~= value then
				fs.writefile(path, value)
			end
		end
	end
end

return m
