local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- 1. Force-locate the local character
local camera = Workspace.CurrentCamera
local character = camera and camera.CameraSubject and camera.CameraSubject.Parent

if not character or not character:FindFirstChild("HumanoidRootPart") then
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            character = obj
            break
        end
    end
end

if not character then return end
local torso = character.HumanoidRootPart

-- Global state management
local activeConnection = nil
local activeClone = nil
local originalPart = nil

-- Clean up any previous state
local function stopAllEffects()
    if activeConnection then activeConnection:Disconnect(); activeConnection = nil end
    if activeClone then activeClone:Destroy(); activeClone = nil end
    if originalPart then originalPart.Transparency = 0; originalPart = nil end
end

-- ==========================================
-- DYNAMIC ENGINE LOGIC
-- ==========================================
local function runOrbit(target)
    stopAllEffects()
    originalPart = target
    originalPart.Transparency = 1

    activeClone = originalPart:Clone()
    activeClone.Transparency = 0
    activeClone.Anchored = true
    activeClone.CanCollide = false
    activeClone.Parent = Workspace

    for _, item in ipairs(activeClone:GetChildren()) do
        if item:IsA("Weld") or item:IsA("ManualWeld") or item:IsA("AccessoryWeld") or item:IsA("WeldConstraint") then
            item:Destroy()
        end
    end

    local radius = 5
    local speed = 4
    local angle = 0

    activeConnection = RunService.RenderStepped:Connect(function(dt)
        if not character or not character.Parent or not torso or not activeClone then
            stopAllEffects()
            return
        end
        angle = angle + (speed * dt)
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius
        activeClone.CFrame = torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
    end)
end

local function runFloat(target)
    stopAllEffects()
    originalPart = target
    originalPart.Transparency = 1

    activeClone = originalPart:Clone()
    activeClone.Transparency = 0
    activeClone.Anchored = true
    activeClone.CanCollide = false
    activeClone.Parent = Workspace

    for _, item in ipairs(activeClone:GetChildren()) do
        if item:IsA("Weld") or item:IsA("ManualWeld") or item:IsA("AccessoryWeld") or item:IsA("WeldConstraint") then
            item:Destroy()
        end
    end

    local hoverHeight = 3
    local speed = 2
    local angle = 0

    activeConnection = RunService.RenderStepped:Connect(function(dt)
        if not character or not character.Parent or not torso or not activeClone then
            stopAllEffects()
            return
        end
        angle = angle + (speed * dt)
        local offsetY = hoverHeight + (math.sin(angle) * 0.5)
        activeClone.CFrame = torso.CFrame * CFrame.new(0, offsetY, 0) * CFrame.Angles(0, angle, 0)
    end)
end

-- ==========================================
-- DYNAMIC GUI GENERATION
-- ==========================================

-- Safe UI container hosting setup
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessoryControlUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = CoreGui:FindFirstChild("RobloxGui") or CoreGui

-- Main Panel
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 240)
mainFrame.Position = UDim2.new(0.5, -160, 0.4, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Accessory Animator"
titleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(200, 80, 80)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    stopAllEffects()
    screenGui:Destroy()
end)

-- Scroll Menu for Items
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 140, 0, 140)
scrollFrame.Position = UDim2.new(0, 15, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 4)
scrollLayout.Parent = scrollFrame

-- Selection Display Tracking Variables
local selectedPart = nil

-- Populate Items List
local itemCount = 0
for _, child in ipairs(character:GetChildren()) do
    local handle = child:IsA("Accessory") and child:FindFirstChild("Handle") or (child:IsA("BasePart") and child ~= torso and child.Name ~= "Head") and child
    if handle then
        itemCount = itemCount + 1
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, -10, 0, 25)
        itemBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
        itemBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        itemBtn.Text = child.Name
        itemBtn.TextSize = 14
        itemBtn.Font = Enum.Font.SourceSans
        itemBtn.Parent = scrollFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = itemBtn

        itemBtn.MouseButton1Click:Connect(function()
            selectedPart = handle
            -- Highlight selected button text visually
            for _, b in ipairs(scrollFrame:GetChildren()) do
                if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(200, 200, 200) end
            end
            itemBtn.TextColor3 = Color3.fromRGB(85, 170, 255)
        end)
    end
end
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, itemCount * 30)

-- Action Controls Panel
local orbitBtn = Instance.new("TextButton")
orbitBtn.Size = UDim2.new(0, 130, 0, 30)
orbitBtn.Position = UDim2.new(0, 170, 0, 55)
orbitBtn.BackgroundColor3 = Color3.fromRGB(40, 60, 100)
orbitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
orbitBtn.Text = "Action: Orbit"
orbitBtn.Font = Enum.Font.SourceSansBold
orbitBtn.TextSize = 14
orbitBtn.Parent = mainFrame

orbitBtn.MouseButton1Click:Connect(function()
    if selectedPart then runOrbit(selectedPart) end
end)

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 130, 0, 30)
floatBtn.Position = UDim2.new(0, 170, 0, 95)
floatBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 60)
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Text = "Action: Float"
floatBtn.Font = Enum.Font.SourceSansBold
floatBtn.TextSize = 14
floatBtn.Parent = mainFrame

floatBtn.MouseButton1Click:Connect(function()
    if selectedPart then runFloat(selectedPart) end
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 130, 0, 35)
stopBtn.Position = UDim2.new(0, 170, 0, 160)
stopBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "Reset Item"
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 14
stopBtn.Parent = mainFrame

stopBtn.MouseButton1Click:Connect(stopAllEffects)
