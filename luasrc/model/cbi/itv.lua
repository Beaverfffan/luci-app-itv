local e=require"nixio.fs"
local t=require"luci.sys"
local t=luci.model.uci.cursor()
m=Map("itv",translate("📺iTV频道源管理"),translate("配合电视直播软件（DIYP、超级直播等），路由器挂载频道源节目单。<font color=\"green\"> 👤微信:</font> iamyaiok <font color=\"blue\">网络优化、OP疑难解决、固件定制</font>."))
m.apply_on_parse=true
s=m:section(TypedSection,"itv")
s.anonymous=true

if nixio.fs.access("/www/tv1")then
s:tab("TV1",translate("📕TV1"),translate("<font color=\"yellow\"><strong>频道源节目单地址为 http://路由器主机名.lan/tv1 或 http://路由器IP/tv1</strong></font>"))
html=[[<a href="http://www.163.com" 163.com</a>]]
conf=s:taboption("TV1",Value,"TV1",nil,translate("<font color=\"yellow\"><strong>分类及直播源地址格式，一定要按直播软件要求写，否则无效。</strong></font>"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/www/tv1")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/tv1",t)
if(luci.sys.call("cmp -s /tmp/tv1 /www/tv1")==1)then
e.writefile("/www/tv1",t)
end
e.remove("/tmp/tv1")
end
end
end

if nixio.fs.access("/www/tv2")then
s:tab("TV2",translate("📗TV2"),translate("<font color=\"yellow\"><strong>节目单挂载地址为 http://路由器主机名.lan/tv2 或 http://路由器IP/tv2</strong></font>"))
conf=s:taboption("TV2",Value,"TV2",nil,translate("<font color=\"yellow\"><strong>分类及直播源地址格式，一定要按直播软件要求写，否则无效。</strong></font>"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/www/tv2")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/tv2",t)
if(luci.sys.call("cmp -s /tmp/tv2 /www/tv2")==1)then
e.writefile("/www/tv2",t)
end
e.remove("/tmp/tv2")
end
end
end

if nixio.fs.access("/www/tv3")then
s:tab("TV3",translate("📘TV3"),translate("<font color=\"yellow\"><strong>节目单挂载地址为 http://路由器主机名.lan/tv3 或 http://路由器IP/tv3</strong></font>"))
conf=s:taboption("TV3",Value,"TV3",nil,translate("<font color=\"yellow\"><strong>分类及直播源地址格式，一定要按直播软件要求写，否则无效。</strong></font>"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/www/tv3")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/tv3",t)
if(luci.sys.call("cmp -s /tmp/tv3 /www/tv3")==1)then
e.writefile("/www/tv3",t)
end
e.remove("/tmp/tv3")
end
end
end

if nixio.fs.access("/www/tv4")then
s:tab("TV4",translate("📙TV4"),translate("<font color=\"yellow\"><strong>节目单挂载地址为 http://路由器主机名.lan/tv4 或 http://路由器IP/tv4</strong></font>"))
conf=s:taboption("TV4",Value,"TV4",nil,translate("<font color=\"yellow\"><strong>分类及直播源地址格式，一定要按直播软件要求写，否则无效。</strong></font>"))
conf.template="cbi/tvalue"
conf.rows=20
conf.wrap="off"
conf.cfgvalue=function(t,t)
return e.readfile("/www/tv4")or""
end
conf.write=function(a,a,t)
if t then
t=t:gsub("\r\n?","\n")
e.writefile("/tmp/tv4",t)
if(luci.sys.call("cmp -s /tmp/tv4 /www/tv4")==1)then
e.writefile("/www/tv4",t)
end
e.remove("/tmp/tv4")
end
end
end

return m


