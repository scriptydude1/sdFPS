--shrimple script to not have BindToRenderStep for EVERY camera type.

local Camera = require(script.Parent)
local RunService = game:GetService("RunService")

RunService:BindToRenderStep("sdfps_camera", Enum.RenderPriority.Camera.Value + 1, function()
    if Camera.CameraType ~= Camera.CustomCameraType.None then
        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    end
    Camera._renderevent:Fire()
end)