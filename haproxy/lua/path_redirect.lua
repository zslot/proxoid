-- This Lua script redirects requests based on
-- HTTP request port or path.

local infra = require('lua.infra')

function path_redirect(txn)
    local result = ''
    local path = txn.sf:path()
    local path_start = string.match(path, '([^/]+)')
    core.log(core.info, path)

    return infra.redirect(path_start)

end

core.register_fetches("path_redirect", path_redirect)
