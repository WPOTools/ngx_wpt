hosts = ngx.shared.hosts
-- TODO(KL):
-- Replace with a function that loads hosts from a json file
hosts:set("B", "<IP-HERE>")
hosts:set("1", "<IP-HERE>")
hosts:set(0, 1)
