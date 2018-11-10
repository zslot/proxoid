
local infra = {}

local redirections = {
    ['region1'] = 'region1_backend',
    ['region2'] = 'region2_backend',
}

function infra.redirect(path)
    if path and redirections[path] then
        return redirections[path]
    else
        return 'default_backend'
    end
end

return infra

