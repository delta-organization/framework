file.CreateDir("delta_lib/imgur")

local cache = {}

function DeltaLib:DownloadImgur(id)
  local promise = self.Promises.new()
  local dataPath = "delta_lib/imgur/" .. id .. ".png"

  if type(cache[id]) == "IMaterial" then
    promise:resolve(cache[id])
  elseif file.Exists(dataPath, "DATA") then
    local mat = Material("../data/" .. dataPath, "noclamp smooth")
    
    cache[id] = mat
    promise:resolve(mat)
  else
    http.Fetch("https://i.imgur.com/" .. id .. ".png", function(body)
      file.Write(dataPath, body)
      local mat = Material("../" .. dataPath, "noclamp smooth")

      cache[id] = mat
      promise:resolve(mat) 
    end, function(error)
      promise:reject(error)
    end)
  end

  return promise
end

--[[ local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawTexturedRect = surface.DrawTexturedRect
local surface_DrawTexturedRectRotated = surface.DrawTexturedRectRotated

function DeltaLib:DrawImgur(id, x, y, w, h, color)
  local downloaded, mat = false, Material("delta_lib/loading.png")

  self:DownloadImgur(id):onResolved(function(img)
    mat, downloaded = img, true
  end)

  surface_SetDrawColor(color or color_white)
  surface_SetMaterial(mat)

  if downloaded then
    surface_DrawTexturedRect(x, y, w, h)
  else
    surface_DrawTexturedRectRotated(x, y, w, h, CurTime() * 360 % 360)
  end
end

hook.Add("HUDPaint", "pog", function()
  DeltaLib:DrawImgur("VW4uzvp", 50, 50, 100, 100)
end) ]]