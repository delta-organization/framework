DeltaLib = DeltaLib || {}

function DeltaLib:LoadFile(path)
  if not string.EndsWith(path, ".lua") then
    path = path .. ".lua"
  end

  local fileName = string.GetFileFromFilename(path)
  local realm = string.sub(fileName, 1, 3)

  if realm == "cl_" then
    if SERVER then
      AddCSLuaFile(path)
    else
      include(path)
    end
  elseif realm == "sh_" then
    if SERVER then
      include(path)
      AddCSLuaFile(path)
    else
      include(path)
    end
  else
    if SERVER then
      include(path)
    end
  end


  MsgC(Color(162, 155, 254), "[DeltaLib] ", color_white, "Loaded file: ", Color(108, 92, 231), fileName, "\n")
end

function DeltaLib:LoadFolder(folder)
  local files, dirs = file.Find(folder .. "/*", "LUA")

  for _, fil in ipairs(files) do
    self:LoadFile(folder .. "/" .. fil)
  end

  for _, dir in ipairs(dirs) do
    self:LoadFolder(folder .. "/" .. dir)
  end
end

if SERVER then
  resource.AddFile("resource/fonts/raleway-variablefont_wght.ttf")
  resource.AddFile("materials/delta_lib/loading.png")
end

DeltaLib:LoadFolder("delta_lib/settings")
DeltaLib:LoadFolder("delta_lib/libraries")
DeltaLib:LoadFolder("delta_lib/elements")

hook.Run("DeltaLib.FinishedLoading")