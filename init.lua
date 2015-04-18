local c = require("load_conf")
local config = c.get_conf("/etc/wpt/conf.json")
local hosts = ngx.shared.hosts
local len = 0

local ch = config["hosts"]

for host in ipairs(ch) do
    hosts:set(ch[host]["id"], ch[host]["host"])
    hosts:set(host, ch[host]["host"])
    len=1+len
end


-- set length of hosts
hosts:set(0, len)
