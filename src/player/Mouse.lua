if game:GetService("RunService"):IsServer() then error("Tried to require a clientside module on the server.") return end

local UserInputService = game:GetService("UserInputService")
local Preferences = require(script.Parent:WaitForChild("Preferences"))

--[[
    Module for mouse-related stuff. Recommended to use instead of a raw UserInputService when handling a mouse

    CLIENTSIDE ONLY!
]]
local mouse = {}

mouse.Locked = true

local leftMouseButton = Instance.new("BindableEvent")
local rightMouseButton = Instance.new("BindableEvent")
mouse.LeftMouseButton = leftMouseButton.Event
mouse.RightMouseButton = rightMouseButton.Event

--UserInputService:GetMouseLocation()
function mouse.getPosition()
    return UserInputService:GetMouseLocation()
end
--UserInputService:GetMouseDelta()
function mouse.getRawDelta()
    return UserInputService:GetMouseDelta()
end
--Movement of a mouse last frame. Takes users sensetivity preference in the calculation.
function mouse.getDelta()
    local delta = UserInputService:GetMouseDelta()
    local sensetivity = Preferences.Sensetivity / 100

    return Vector2.new(delta.X * sensetivity, delta.Y * sensetivity)
end

return mouse