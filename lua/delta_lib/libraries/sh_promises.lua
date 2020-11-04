local PROMISE = {}
PROMISE.__index = PROMISE

local PROMISE_PENDING = 0
local PROMISE_RESOLVED = 1
local PROMISE_REJECTED = 2

function PROMISE.new()
  local self = setmetatable({}, PROMISE)
  self.status = PROMISE_PENDING
  return self
end

function PROMISE.all(tbl)
  local promise = PROMISE.new()
  if #tbl == 0 then
    return promise:resolve({})
  end

  local promises = {}

  for i, prom in ipairs(tbl) do
    prom:onResolved(function(data)
      promises[i] = data

      if #promises == #tbl then
        promise:resolve(promises)
      end
    end):onRejected(function(err)
      promise:reject(err)
    end)
  end

  return promise
end

function PROMISE:resolve(...)
  if self.state ~= PROMISE_PENDING then return end

  if self.resolveFunc then
    self.resolveFunc(...)
  else
    self.resolveData = {...}
  end

  self.status = PROMISE_RESOLVED
end

function PROMISE:reject(...)
  if self.state ~= PROMISE_PENDING then return end

  if self.rejectFunc then
    self.rejectFunc(...)
  else
    self.rejectData = {...}
  end

  self.status = PROMISE_REJECTED
end

function PROMISE:onResolved(func)
  if self.status == PROMISE_RESOLVED then
    func(unpack(self.resolveData))
  else
    self.resolveFunc = func
  end

  return self
end

function PROMISE:onRejected(func)
  if self.status == PROMISE_REJECTED then
    func(unpack(self.rejectData))
  else
    self.rejectFunc = func
  end

  return self
end

DeltaLib.Promises = PROMISE