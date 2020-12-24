DeltaLib.Http = DeltaLib.Http or {}

function DeltaLib.Http:Request(method, url, body, headers)
  headers = headers or {}
  local promise = DeltaLib.Promise.new()

  local params = body
  if istable(body) then
    headers["Content-Type"] = "application/json"
    params = util.TableToJSON(body)
  end

  HTTP({
    method = method,
    url = url,
    body = params,
    headers = headers,
    type = istable(body) and "application/json",
    success = function(status, body, headers)
      local isJson = string.find(headers["Content-Type"], "application/json", nil, true) ~= nil
      if isJson then
        body = util.JSONToTable(body) or body
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

function DeltaLib.Http:Get(...)
  return self:Request("GET", ...)
end

function DeltaLib.Http:Post(...)
  return self:Request("POST", ...)
end

function DeltaLib.Http:Patch(...)
  return self:Request("PATCH", ...)
end

function DeltaLib.Http:Put(...)
  return self:Request("PUT", ...)
end

function DeltaLib.Http:Delete(...)
  return self:Request("DELETE", ...)
end

function DeltaLib.Http:Head(...)
  return self:Request("HEAD", ...)
end

function DeltaLib.Http:Options(...)
  return self:Request("OPTIONS", ...)
end