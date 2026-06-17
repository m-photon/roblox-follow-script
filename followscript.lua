-- BRUTE-FORCE EXECUTOR REWRITE
local RunService = game:GetService("RunService")
local workspace = game:GetService("Workspace")

-- Brute-force locate the local character model without using Players.LocalPlayer
local camera = workspace.CurrentCamera
local character = camera and camera.CameraSubject and camera.CameraSubject.Parent

if not character or not character:FindFirstChild("HumanoidRootPart") then
    -- Fallback: grab the first model in workspace matching a player name
    for _, obj in ipairs(workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            character = obj
            break
        end
    end
end

if not character then
    print("[Error] Could not force-detect character model.")
    return
end

local torso = character.HumanoidRootPart

-- Aggressive search for any valid accessory structure
local targetHandle = nil
for _, child in ipairs(character:GetChildren()) do
    if child:IsA("Accessory") and child:FindFirstChild("Handle") then
        targetHandle = child.Handle
        break
    elseif child:IsA("BasePart") and (child.Name:lower():match("back") or child.Name:lower():match("mesh")) then
        targetHandle = child
        break
    end
end

if not targetHandle then
    print("[Error] No target handle or accessory found on the character model.")
    return
end

-- Completely hide the original visual part safely
targetHandle.Transparency = 1

-- Build the isolated client clone
local localClone = targetHandle:Clone()
localClone.Transparency = 0
localClone.Anchored = true
localClone.CanCollide = false
localClone.Parent = workspace

-- Clear out any latent engine constraints
for _, item in ipairs(localClone:GetChildren()) do
    if item:IsA("Weld") or item:IsA("ManualWeld") or item:IsA("AccessoryWeld") or item:IsA("WeldConstraint") then
        item:Destroy()
    end
end

-- Orbit Properties
local radius = 5
local speed = 4
local angle = 0

print("[Success] Orbiting engine initialized for: " .. character.Name)

-- Frame-locked render loop execution
local connection
connection = RunService.RenderStepped:Connect(function(dt)
    if not character or not character.Parent or not torso or not localClone then
        if connection then connection:Disconnect() end
        if localClone then localClone:Destroy() end
        return
    end
    
    angle = angle + (speed * dt)
    
    local offsetX = math.cos(angle) * radius
    local offsetZ = math.sin(angle) * radius
    
    -- Force-apply the calculation directly to the global CFrame array
    localClone.CFrame = torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
end)
