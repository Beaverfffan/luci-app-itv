module("luci.controller.itv",package.seeall)
function index()
if not nixio.fs.access("/etc/config/itv")then
return
end
local e
e=entry({"admin","services","itv"},cbi("itv"),_("iTV频道源"),0)
e.dependent=true
end

