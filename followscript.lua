-- CLIENT-SIDE LOCAL CLONE VERSION
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Torso = Character:WaitForChild("HumanoidRootPart")

-- 1. Locate your character's current accessory
local targetAccessory = nil
for _, child in ipairs(Character:GetChildren()) do
    if child:IsA("Accessory") and child:FindFirstChild("Handle") then
        targetAccessory = child
        break
    end
end

if not targetAccessory then
    warn("Could not find any accessory to clone!")
    return
end

local originalHandle = targetAccessory.Handle

-- 2. Hide the original back accessory so it doesn't clip
originalHandle.Transparency = 1

-- 3. Create a local clone of the handle that only you control
local localClone = originalHandle:Clone()
localClone.Transparency = 0
localClone.Anchored = true
localClone.CanCollide = false
localClone.Parent = workspace

-- Strip any original physical constraints/welds out of our clone
for _, item in ipairs(localClone:GetChildren()) do
    if item:IsA("Weld") or item:IsA("ManualWeld") or item:IsA("AccessoryWeld") then
        item:Destroy()
    end
end

-- 4. Orbit Settings
local radius = 5
local speed = 4
local angle = 0

-- 5. Animate frame-by-frame on your client render step
local connection
connection = RunService.RenderStepped:Connect(function(dt)
    -- Clean up the loop if you reset or change maps
    if not Character or not Character.Parent or not Torso or not localClone then
        if connection then connection:Disconnect() end
        if localClone then localClone:Destroy() end
        return
    end
    
    angle = angle + (speed * dt)
    
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    
    -- Smoothly move the cloned handle around your position frame by frame
    localClone.CFrame = Torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
end)
