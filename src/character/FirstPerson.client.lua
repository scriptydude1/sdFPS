local scriptCameraType = "FirstPerson"

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local plrScripts =  player.PlayerScripts:WaitForChild("sdFPS")
local Camera, Mouse = require(plrScripts.Camera), require(plrScripts.Mouse)

local CFRAME_EYELEVEL = 1.75
local MAX_LOOK_LENGTH = 900000
local lastMouseDelta = Vector2.new()

local function vectorToCf(mouseDelta, offset)
    local pitch = CFrame.Angles(-math.clamp(mouseDelta.Y, -math.pi/3, math.pi/2.5), 0, 0)
    local yaw = CFrame.Angles(0, -mouseDelta.X, 0)

    return CFrame.new(offset) * yaw * pitch
end


Camera.RenderStep:Connect(function()
    if Camera.CameraType == Camera.CustomCameraType[scriptCameraType]  then
        local mouseDelta = Mouse.getDelta() + lastMouseDelta
        local positionCf = Vector3.new(HRP.CFrame.X, HRP.CFrame.Y + CFRAME_EYELEVEL, HRP.CFrame.Z)

        local cameraCf = mouseDelta == Vector2.zero 
        and vectorToCf(lastMouseDelta, positionCf) or vectorToCf(mouseDelta, positionCf)

        Camera.setCFrame(cameraCf)
        lastMouseDelta = Vector2.new(mouseDelta.X, math.clamp(mouseDelta.Y, -1.5, 1.5))
        print(lastMouseDelta)

        local updatedCameraCf = CFrame.new(HRP.Position, Vector3.new(cameraCf.LookVector.X * MAX_LOOK_LENGTH, positionCf.Y + CFRAME_EYELEVEL, cameraCf.LookVector.Z * MAX_LOOK_LENGTH))
        HRP.CFrame = updatedCameraCf 
    end
end)