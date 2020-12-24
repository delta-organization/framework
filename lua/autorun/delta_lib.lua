DeltaLib = DeltaLib || {}

DeltaLib.REALM_CLIENT = "cl_"
DeltaLib.REALM_SERVER = "sv_"
DeltaLib.REALM_SHARED = "sh_"

function DeltaLib:LoadFile(path, realmOverride)
  if not string.EndsWith(path, ".lua") then
    path = path .. ".lua"
  end

  local fileName = string.GetFileFromFilename(path)
  local realm = realmOverride or string.sub(fileName, 1, 3)

  if realm == DeltaLib.REALM_CLIENT then
    if SERVER then
      AddCSLuaFile(path)
    else
      include(path)
    end
  elseif realm == DeltaLib.REALM_SHARED then
    if SERVER then
      include(path)
      AddCSLuaFile(path)
    else
      include(path)
    end
  elseif realm == DeltaLib.REALM_SERVER then
    if SERVER then
      include(path)
    end
  else
    -- invalid realm
    print('inv realm')
    return
  end


  MsgC(Color(162, 155, 254), "[DeltaLib] ", color_white, "Loaded file: ", Color(108, 92, 231), fileName, "\n")
end

function DeltaLib:LoadFolder(folder, realm)
  local files, dirs = file.Find(folder .. "/*", "LUA")

  for _, fil in ipairs(files) do
    self:LoadFile(folder .. "/" .. fil, realm)
  end

  for _, dir in ipairs(dirs) do
    self:LoadFolder(folder .. "/" .. dir, realm)
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