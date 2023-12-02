local scriptCameraType = "FirstPerson"

local player = game:GetService("Players").LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local HRP = character:WaitForChild("HumanoidRootPart")

local plrScripts =  player.PlayerScripts:WaitForChild("sdFPS")
local Camera, Mouse = require(plrScripts.Camera), require(plrScripts.Mouse)

local CFRAME_EYELEVEL = 1.75
local MAX_LOOK_LENGTH = 900000
local lastMouseDelta = Vector2.new()

--parts that's hidden when player is in the firstperson mode
local hiddenCharacterParts = {}
local filledHiddenParts = false

local function vectorToCf(mouseDelta, offset)
    local pitch = CFrame.Angles(-math.clamp(mouseDelta.Y, -math.pi/3, math.pi/2.5), 0, 0)
    local yaw = CFrame.Angles(0, -mouseDelta.X, 0)

    return CFrame.new(offset) * yaw * pitch
end

local function proccessHidden()
    if filledHiddenParts then return end
    for i, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") or part:IsA("Accessory") then

            if part:IsA("Accessory") then
                part = part:FindFirstChild("Handle")
            end
            if not part then continue end

            if part.Transparency ~= 1 then
                part.Transparency = 1
                table.insert(hiddenCharacterParts, part)
            end
        end
    end

    filledHiddenParts = true
end
local function clearHidden()
    if not filledHiddenParts then return end

    for i, part in pairs(hiddenCharacterParts) do
        if part then
            part.Transparency = 0
            table.remove(hiddenCharacterParts, i)
        end
    end

    filledHiddenParts = false
end


Camera.RenderStep:Connect(function()
    if Camera.CameraType == Camera.CustomCameraType[scriptCameraType]  then
        proccessHidden()
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
        clearHidden()
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