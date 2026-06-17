-- CLIENT-SIDE EXECUTOR VERSION (Paste into your executor)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Torso = Character:WaitForChild("HumanoidRootPart")

-- Find any accessory on your back/character
local targetAccessory = nil
for _, child in ipairs(Character:GetChildren()) do
    if child:IsA("Accessory") and child:FindFirstChild("Handle") then
        targetAccessory = child
        break
    end
end

if not targetAccessory then
    warn("No accessory found to orbit!")
    return
end

local handle = targetAccessory.Handle

-- Break the weld locally so it can move away from your back
local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("ManualWeld") or handle:FindFirstChild("AccessoryWeld")
if weld then
    weld:Destroy()
end

-- Configure the circle settings
local radius = 5
local speed = 4
local angle = 0

-- This loop runs locally every frame right before rendering
RunService.RenderStepped:Connect(function(dt)
    if not Character or not Character.Parent or not Torso then return end
    
    angle = angle + (speed * dt)
    
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    
    -- Smoothly update the accessory position on your screen
    handle.CFrame = Torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
end)
