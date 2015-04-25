function string:split(delimiter)
   local result = { }
   local from = 1
   local delim_from, delim_to = string.find( self, delimiter, from )
   while delim_from do
      table.insert( result, string.sub( self, from , delim_from-1 ) )
      from = delim_to + 1
      delim_from, delim_to = string.find( self, delimiter, from )
   end
   table.insert( result, string.sub( self, from ) )
   return result
end


function starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end


function get_path()
    return ngx.var.request.split(ngx.var.request, " ")[2] 
end


function select_sample(args, path)
    if args["test"] then
        return args["test"]
    elseif starts(path, "/result") then
        return path
    end

    return false
end


-- If the `test` query param exist then return it
-- path. Otherwise return the request path
function get_id()
    local args = ngx.req.get_uri_args()
    local path = get_path()
    local sample = select_sample(args, path)

    local id = nil
    if sample then
        local captures, err = ngx.re.match(sample, "[1-9]+_(?<id>[A-Za-z])[A-Za-z]+_[1-9]", "iox")
        if captures["id"] then
            id = captures["id"]
        end
    end
    return id
end


local hosts = ngx.shared.hosts
local id = get_id()

if id and hosts.get(hosts, id) then
    local host = hosts.get(hosts, id)
    ngx.var.target = host
else
    -- Random Round Robin algorithm
    local len = hosts.get(hosts, 0)
    math.randomseed(os.time()) 
    local index = math.random(1, len)
    local host = hosts.get(hosts, index)
    ngx.var.target = host
end
