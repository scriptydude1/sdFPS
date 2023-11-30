local Mouse = require(script.Parent:WaitForChild("Mouse"))

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

RunService:BindToRenderStep("sdfps_mouselock", Enum.RenderPriority.Last.Value + 1, function()
    if Mouse.Locked then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end)