
local infra = {}

-- port redirection and path redirection are pointing to the same lookup function

local servicesDefs = {
    ['glance'] = {
        ['port'] = '9292',
        ['path'] = 'image',
    },
    ['keystone'] = {
        ['port'] = '5000',
        ['path'] = 'identity',
    },
}

local regionsLookup = {
    ['region1'] = {
        --['url'] = 'http://192.168.142.10',
        ['configured_as'] = 'region1_backend'
    },
    ['region2'] = {
        --['url'] = 'http://192.168.142.20',
        ['configured_as'] = 'region1_backend',
    },
    -- local region
    ['default'] = {
        --['url'] = 'http://192.168.142.30',
        ['configured_as'] = 'default_backend',
    },
}

local serviceSelector = {
    ['glance'] = {
        ['dest'] = 'glance',
    },
    ['keystone'] = {
        ['dest'] = 'keystone',
    },
    ['9292'] = {
        ['dest'] = 'glance',
    },
    ['5000'] = {
        ['dest'] = 'keystone',
    },
    ['default'] = {
        ['dest'] = 'error_unknown_service',
    },
}


function infra.redirect(scope, path_or_port)
    local region = regionsLookup[scope].configured_as or regionsLookup['default'].configured_as
    local service = serviceSelector[path_or_port] or serviceSelector['default']
    return region, service
end

return infra

