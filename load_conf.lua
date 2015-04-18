module("load_conf", package.seeall)
function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

local c = nil

function get_conf(conf)
    if c then return c end
    local cjson = require("cjson")
    local fc = readAll(conf)
    c = cjson.decode(fc)
    return c
end
