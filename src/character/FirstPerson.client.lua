local scriptCameraType = "FirstPerson"

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local plrScripts =  player.PlayerScripts:WaitForChild("sdFPS")
local Camera, Mouse = require(plrScripts.Camera), require(plrScripts.Mouse)

local CFRAME_EYELEVEL = 1.75
local MAX_LOOK_LENGTH = 900000
local lastMouseDelta = Vector2.new()

local hideCharacter = true

local function vectorToCf(mouseDelta, offset)
    local pitch = CFrame.Angles(-math.clamp(mouseDelta.Y, -math.pi/3, math.pi/2.5), 0, 0)
    local yaw = CFrame.Angles(0, -mouseDelta.X, 0)

    return CFrame.new(offset) * yaw * pitch
end

Camera.RenderStep:Connect(function()
    if Camera.CameraType == Camera.CustomCameraType[scriptCameraType]  then
        hideCharacter = true
        local mouseDelta = Mouse.getDelta() + lastMouseDelta
        local positionCf = Vector3.new(HRP.CFrame.X, HRP.CFrame.Y + CFRAME_EYELEVEL, HRP.CFrame.Z)

        local cameraCf = mouseDelta == Vector2.zero 
        and vectorToCf(lastMouseDelta, positionCf) or vectorToCf(mouseDelta, positionCf)

        Camera.setCFrame(cameraCf)
        lastMouseDelta = Vector2.new(mouseDelta.X, math.clamp(mouseDelta.Y, -1.5, 1.5))
        print(lastMouseDelta)

        local updatedCameraCf = CFrame.new(HRP.Position, Vector3.new(cameraCf.LookVector.X * MAX_LOOK_LENGTH, positionCf.Y + CFRAME_EYELEVEL, cameraCf.LookVector.Z * MAX_LOOK_LENGTH))
        HRP.CFrame = updatedCameraCf
    else
        hideCharacter = false
    end
end)

RunService:BindToRenderStep("sdfps_firstperson_hidechar", Enum.RenderPriority.Character.Value - 5, function()
    for i,part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            if hideCharacter then
                part.LocalTransparencyModifier = 1
            else
                part.LocalTransparencyModifier = 0
            end
        end
    end
end)

--for debugging purposes
Mouse.LeftMouseButton:Connect(function()
    print("haiii")
    if Camera.CameraType == Camera.CustomCameraType.FirstPerson then
        Camera.CameraType = Camera.CustomCameraType.None
    else
        Camera.CameraType = Camera.CustomCameraType.FirstPerson
    end
end)