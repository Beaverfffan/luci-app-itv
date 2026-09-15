--[[
  luci-app-itv  ---  controller

  相对原版的改动：
    * 补上被原作者省略的缩进
    * 原先用 ``entry(...)`` 的返回值直接写 ``e.dependent = true``，
      这里显式先取出 e 再设置，避免依赖「函数最后一条语句的返回值」这种隐晦写法
    * 菜单排序从 0 改为 30，避免插到 Services 分组最前面
--]]

module("luci.controller.itv", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/itv") then
		return
	end

	local e = entry({"admin", "services", "itv"}, cbi("itv"), _("iTV频道源"), 30)
	e.dependent = true
end
