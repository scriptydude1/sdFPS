if game:GetService("RunService"):IsServer() then error("Tried to require a clientside module on the server.") return end

--[[
    Camera module used for handling workspace.CurrentCamera

    Contains enum of a different custom camera types.
]]
local cam = {}

--Enum holding different camera types.
cam.CustomCameraType = 
{
    ["None"] = 0, --When this is set as cam.CameraType, camera is not going to be forced to Scripted type anymore.
    ["FirstPerson"] = 1
}
cam.CameraType = cam.CustomCameraType.FirstPerson

cam._renderevent = Instance.new("BindableEvent")
cam.RenderStep = cam._renderevent.Event

function cam.setCFrame(cframe)
    workspace.CurrentCamera.CFrame = cframe
end
function cam.getCFrame()
    return workspace.CurrentCamera.CFrame
end
return cam