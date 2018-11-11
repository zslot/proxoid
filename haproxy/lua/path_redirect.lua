-- This Lua script redirects requests based on
-- HTTP request port or path.

local infra = require('lua.infra')
local json = require('lua.json')
local helper = require('lua.helper')

local function process()

end

local function path_redirect(txn)
    local path = txn.sf:path()
    local path_start = string.match(path, '([^/]+)')
    core.log(core.info, path)


    --REQ: curl -g -i -X GET "http://192.168.122.10/image/v2/images?marker=None" -H "User-Agent: osc-lib/1.9.0 keystoneauth1/3.4.0 python-requests/2.18.4 CPython/2.7.12" -H "X-Auth-Token: {SHA1}440ed18fee96956dbd0683fd6953406bc8cbe603"
    --Resetting dropped connection: 192.168.122.10
    --200 671
    --RESP: [200] Date: Sun, 11 Nov 2018 09:26:44 GMT Server: Apache/2.4.18 (Ubuntu) Content-Length: 671 Content-Type: application/json x-openstack-request-id: req-d0484392-79af-454b-825b-074a27150aa9 Connection: close 
    --RESP BODY: {"images": [{"status": "active", "name": "cirros-0.3.5-x86_64-disk", "tags": [], "container_format": "bare", "created_at": "2018-11-10T16:57:51Z", "size": 13267968, "disk_format": "qcow2", "updated_at": "2018-11-10T16:57:52Z", "visibility": "public", "self": "/v2/images/6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8", "min_disk": 0, "protected": false, "id": "6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8", "file": "/v2/images/6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8/file", "checksum": "f8ab98ff5e73ebab884d80c9dc9c7290", "owner": "2a507db2fdb142ff826c0ba5ee8d77ca", "virtual_size": null, "min_ram": 0, "schema": "/v2/schemas/image"}], "schema": "/v2/schemas/images", "first": "/v2/images"}


    local uri = 'http://192.168.122.10:80 "GET /image/v2/images HTTP/1.1"'
    local headers = {
        ["User-Agent"] =  "osc-lib/1.9.0 keystoneauth1/3.4.0 python-requests/2.18.4 CPython/2.7.12",
        ["X-Auth-Token"] ="{SHA1}440ed18fee96956dbd0683fd6953406bc8cbe603",
    }
    local response_json = '{"images": [{"status": "active", "name": "cirros-0.3.5-x86_64-disk", "tags": [], "container_format": "bare", "created_at": "2018-11-10T16:57:51Z", "size": 13267968, "disk_format": "qcow2", "updated_at": "2018-11-10T16:57:52Z", "visibility": "public", "self": "/v2/images/6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8", "min_disk": 0, "protected": false, "id": "6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8", "file": "/v2/images/6356ec4f-1d58-4a6f-bf66-8133bcc9e9b8/file", "checksum": "f8ab98ff5e73ebab884d80c9dc9c7290", "owner": "2a507db2fdb142ff826c0ba5ee8d77ca", "virtual_size": null, "min_ram": 0, "schema": "/v2/schemas/image"}], "schema": "/v2/schemas/images", "first": "/v2/images"}'
    local response_struct = json.decode(response_json)

    core.log(core.info, helper.dump(response_struct))

    local hdr = txn.http:req_get_headers()
    core.log(core.info, 'TXN: ' .. helper.dump(txn.http:req_get_headers()))

    local encoded = hdr['x-auth-token'][0]
    local x = string.gmatch(encoded, "{.*}")
    
    
    -- core.log(core.info, 'sc: ' .. x)
    

    local reg, serv =  infra.redirect('region1', path_start)
    return reg
end

core.register_fetches("path_redirect", path_redirect)


local function port_redirect(txn)
  local base = txn.sf:base()
  local host, port, rest = string.match(base, '([^:]+):([^/]+)/?(.+)]?')
  txn.Info(txn, 'Port: ' .. port)
  local reg, serv =  infra.redirect('region1', port)
  return reg
end

core.register_fetches("host_redirect", port_redirect)

