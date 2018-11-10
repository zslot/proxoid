-- This Lua script redirects requests based on
-- HTTP request port or path.

function path_redirect(txn)
  local result = ''
  local path = txn.sf:path()
  local path_start = string.match(path, '([^/]+)')
  core.log(core.info, path)
  if path_start == 'region1' then
    result = 'region1_backend'
  elseif path_start == 'region2' then
    result = 'region2_backend'
  else
    result = 'default_backend'
  end
  return result
end

core.register_fetches("path_redirect", path_redirect)
