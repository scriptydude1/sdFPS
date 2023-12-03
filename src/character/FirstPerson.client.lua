local scriptCameraType = "FirstPerson"

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")
local Head = character:WaitForChild("Head")

local plrScripts =  player.PlayerScripts:WaitForChild("sdFPS")
local Camera, Mouse = require(plrScripts.Camera), require(plrScripts.Mouse)
local Preferences = require(plrScripts.Preferences)

local CFRAME_EYELEVEL = 1.75
local MAX_LOOK_LENGTH = 900000
local LERP_ALPHA = 0.45
local LOWEST_INT = -548305890385023850983508
local lastMouseDelta = Vector2.new()

local hideCharacter = true
--[[
    Key - name of the bodypart
    Value - preferred Transparency value
]]
local hideIgnore = {["Left Arm"] = 0.25, ["Right Arm"] = 0.25}

local function vectorToCf(mouseDelta, offset)
    local pitch = CFrame.Angles(-math.clamp(mouseDelta.Y, -math.pi/3, math.pi/2.5), 0, 0)
    local yaw = CFrame.Angles(0, -mouseDelta.X, 0)

    return CFrame.new(offset) * yaw * pitch
end

Camera.RenderStep:Connect(function()
    if Camera.CameraType == Camera.CustomCameraType[scriptCameraType]  then
        hideCharacter = true

        --evil code. Basically if rawinput = false then smooth out mouse with Lerp
        local mouseDelta = Preferences.Mouse.RawInput
        and Mouse:getDelta() + lastMouseDelta or lastMouseDelta:Lerp(Mouse:getDelta() + lastMouseDelta, LERP_ALPHA)

        local yPosition = Preferences.Camera.FP_UseHeadHeight
        and Head.CFrame.Y or HRP.CFrame.Y + CFRAME_EYELEVEL
        local positionCf = Vector3.new(HRP.CFrame.X, yPosition, HRP.CFrame.Z)

        local cameraCf = mouseDelta == Vector2.zero 
        and vectorToCf(lastMouseDelta, positionCf) or vectorToCf(mouseDelta, positionCf)

        Camera.setCFrame(cameraCf)
        lastMouseDelta = Vector2.new(mouseDelta.X, math.clamp(mouseDelta.Y, -1.5, 1.5))

        local updatedCameraCf = CFrame.new(HRP.Position, Vector3.new(cameraCf.LookVector.X * MAX_LOOK_LENGTH, positionCf.Y + CFRAME_EYELEVEL, cameraCf.LookVector.Z * MAX_LOOK_LENGTH))
        HRP.CFrame = updatedCameraCf
    else
        hideCharacter = false
    end
end)

RunService:BindToRenderStep("sdfps_firstperson_hidechar", Enum.RenderPriority.Character.Value - 5, function()
    for i,part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CastShadow = false
            if hideCharacter then
                if hideIgnore[part.Name] then
                   part.LocalTransparencyModifier = hideIgnore[part.Name]
                else
                    part.LocalTransparencyModifier = 1
                end
            else
                part.LocalTransparencyModifier = 0
                part.Material = Enum.Material.Plastic
            end
        end
    end
end)

--for debugging purposes
Mouse.LeftMouseButton:Connect(function()
    if Camera.CameraType == Camera.CustomCameraType.FirstPerson then
        Camera.CameraType = Camera.CustomCameraType.None
    else
        Camera.CameraType = Camera.CustomCameraType.FirstPerson
    end
end)