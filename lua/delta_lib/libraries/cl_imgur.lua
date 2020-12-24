file.CreateDir("delta_lib/imgur")

local cache, queue = {}, {}
local loadingMat = Material("delta_lib/loading.png")

function DeltaLib:DownloadImgur(id)
  local promise = self.Promise.new()
  local dataPath = "delta_lib/imgur/" .. id .. ".png"

  if type(cache[id]) == "IMaterial" then
    promise:resolve(cache[id])
  elseif file.Exists(dataPath, "DATA") then
    local mat = Material("../data/" .. dataPath, "noclamp smooth")
    
    cache[id] = mat
    promise:resolve(mat)
  else
    self.Http:Get("https://i.imgur.com/" .. id .. ".png")
      :resolved(function(body)
        file.Write(dataPath, body)
        local mat = Material("../" .. dataPath, "noclamp smooth")

        cache[id] = mat
        promise:resolve(mat) 
      end)
      :rejected(function(reason)
        promise:reject(reason)
      end)
  end

  return promise
end

local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local CurTime = CurTime

function DeltaLib:DrawImgur(x, y, w, h, color, id, ang)
  local mat
  if not cache[id] then
    mat = loadingMat

    if queue[id] then return end -- Stop if it's already downloading

    queue[id] = true
    
    self:DownloadImgur(id)
      :resolved(function()
        queue[id] = nil
      end)
  else
    mat = cache[id]
  end

  surface_SetMaterial(mat)
  surface_SetDrawColor(color)

  if ang and queue[id] then
    surface_DrawTexturedRectRotated(x, y, w, h, ang and ang or (CurTime() * 360 % 360))
  else
    surface_DrawTexturedRect(x, y, w, h)
  end
end