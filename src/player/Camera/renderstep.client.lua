--shrimple script to not have BindToRenderStep for EVERY camera type.

local Preferences = require(script.Parent.Parent:WaitForChild("Preferences"))
local Camera = require(script.Parent)
local Mouse = require(script.Parent.Parent:WaitForChild("Mouse"))
local RunService = game:GetService("RunService")

local defaultPref = table.clone(Preferences.Camera)
defaultPref.FOV = 70

RunService:BindToRenderStep("sdfps_camera", Enum.RenderPriority.Camera.Value + 1, function()
    if Camera.CameraType ~= Camera.CustomCameraType.None then
        Camera.applyPrefs(Preferences.Camera)
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
        Mouse.Locked = false
    else
        Camera.applyPrefs(defaultPref)
    end
    Camera._renderevent:Fire()
end)