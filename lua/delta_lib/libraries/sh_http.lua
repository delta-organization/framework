DeltaLib.Http = DeltaLib.Http or {}

local tonumber = tonumber
local string_format, string_char = string.format, string.char
local table_concat = table.concat

-- Helper functions for x-www-form-urlencoded data
local function encodepart(str)
  return str:gsub("%W", function(part)
    return (part ~= " ") and string_format("%%%02x", part:byte()) or "+"
  end)
end

local function urlencode(tbl)
  local res = DeltaLib:MapTable(tbl, function(val, key)
    return encodepart(key) .. "=" .. encodepart(val) 
  end)

  return table_concat(res, "&")
end

local function decodepart(str)
  return str:gsub("%%(%x%x)", function(part)
    return string_char(tonumber(part, 16))
  end)
end

local function urldecode(str)
  if not str:match("=") then return decodepart(str) end

  local result = {}
  for k, v in str:gmatch("([^=&]*)=([^&]*)") do
    k, v = k:gsub("%+", "%%20"), v:gsub("%+", "%%20")
    k, v = decodepart(k), decodepart(v)

    result[k] = v
  end

  return result
end

local contentTypes = {
  ["application/x-www-form-urlencoded"] = {
    encode = urlencode,
    decode = urldecode
  },
  ["application/json"] = {
    encode = util.TableToJSON,
    decode = util.JSONToTable
  }
}

local function findContentType(header)
  for contentType, funcs in pairs(contentTypes) do
    if header:find(contentType, nil, true) ~= nil then
      return funcs
    end
  end

  return false
end

function DeltaLib.Http:Request(method, url, body, headers)
  headers = headers or {}
  local promise = DeltaLib.Promise.new()

  if istable(body) then
    headers["Content-Type"] = headers["Content-Type"] or "application/json"
    
    local contentType = findContentType(headers["Content-Type"])
    if contentType and isfunction(contentType.encode) then
      body = contentType.encode(body) or body
    end
  end

  HTTP({
    method = method,
    url = url,
    body = body,
    headers = headers,
    type = headers["Content-Type"],
    success = function(status, body, headers)
      local contentType = findContentType(headers["Content-Type"])
      if contentType and isfunction(contentType.decode) then
        body = contentType.decode(body) or body
      end

      promise:resolve(body, status, headers)
    end,
    failed = function(reason)
      print(string.format("[DeltaLib] %s Request Failed (%s): %s", method, url, reason))

      promise:reject(reason)
    end
  })

  return promise
end

local httpMethods = {"get", "post", "patch", "put", "delete", "head", "options"}
for _, method in ipairs(httpMethods) do
  local methodName = method[1]:upper() .. method:sub(2, #method)

  DeltaLib.Http[methodName] = function(self, ...)
    return self:Request(method:upper(), ...)
  end
end