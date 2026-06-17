local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 1. Locate the Local Player and Character context cleanly
local player = Players.LocalPlayer
if not player then
    -- Fallback for environments where LocalPlayer is sandboxed
    player = Players:GetPlayers()
end

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

if not character then 
    warn("[Error] Character could not be found.")
    return 
end

local torso = character.HumanoidRootPart
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Global engine tracking states
local activeConnection = nil
local activeClone = nil
local originalPart = nil

-- Memory eraser to safely clear tracking duplicates
local function clearPreviousClones()
    if activeConnection then activeConnection:Disconnect(); activeConnection = nil end
    if activeClone then activeClone:Destroy(); activeClone = nil end
    if originalPart then originalPart.Transparency = 0; originalPart = nil end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj.Name == "AnimatedAccessoryClone" then
            obj:Destroy()
        end
    end
end

-- ==========================================
-- ANIMATION CALCULATIONS (No Auto-Run)
-- ==========================================
local function runOrbit(target)
    clearPreviousClones()
    originalPart = target
    originalPart.Transparency = 1

    activeClone = originalPart:Clone()
    activeClone.Name = "AnimatedAccessoryClone"
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
            clearPreviousClones()
            return
        end
        angle = angle + (speed * dt)
        local offsetX = math.cos(angle) * radius
        local offsetZ = math.sin(angle) * radius
        activeClone.CFrame = torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
    end)
end

local function runFloat(target)
    clearPreviousClones()
    originalPart = target
    originalPart.Transparency = 1

    activeClone = originalPart:Clone()
    activeClone.Name = "AnimatedAccessoryClone"
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
            clearPreviousClones()
            return
        end
        angle = angle + (speed * dt)
        local offsetY = hoverHeight + (math.sin(angle) * 0.5)
        activeClone.CFrame = torso.CFrame * CFrame.new(0, offsetY, 0) * CFrame.Angles(0, angle, 0)
    end)
end

-- ==========================================
-- SCREEN-CENTERED DRAGGABLE UI SCREEN
-- ==========================================

-- Remove old copies to clear execution stacking
if playerGui:FindFirstChild("AccessoryCentricUI") then
    playerGui.AccessoryCentricUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessoryCentricUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Main Centered Framework Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 240)
-- Centered exactly on screen scale geometry
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Manual Dragging Engine Implementation (Bypasses deprecated UI properties)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Window Components
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Accessory Control Center"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 15
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(220, 70, 70)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.Parent = mainFrame
closeBtn.MouseButton1Click:Connect(function()
    clearPreviousClones()
    screenGui:Destroy()
end)

-- Scrolling Panel for Accessory Names
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 145, 0, 150)
scrollFrame.Position = UDim2.new(0, 15, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
scrollFrame.BorderSizePixel = 0
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = mainFrame

local scrollLayout = Instance.new("UIListLayout")
scrollLayout.Padding = UDim.new(0, 4)
scrollLayout.Parent = scrollFrame

local selectedPart = nil
local itemCount = 0

-- Scrape items safely without pre-triggering calculation loops
for _, child in ipairs(character:GetChildren()) do
    local handle = child:IsA("Accessory") and child:FindFirstChild("Handle") or (child:IsA("BasePart") and child ~= torso and child.Name ~= "Head") and child
    if handle then
        itemCount = itemCount + 1
        local itemBtn = Instance.new("TextButton")
        itemBtn.Size = UDim2.new(1, -5, 0, 25)
        itemBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        itemBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        itemBtn.Text = child.Name
        itemBtn.TextSize = 13
        itemBtn.Font = Enum.Font.SourceSans
        itemBtn.Parent = scrollFrame
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 4)
        btnCorner.Parent = itemBtn

        itemBtn.MouseButton1Click:Connect(function()
            selectedPart = handle
            for _, b in ipairs(scrollFrame:GetChildren()) do
                if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(220, 220, 220) end
            end
            itemBtn.TextColor3 = Color3.fromRGB(65, 150, 255)
        end)
    end
end
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, itemCount * 30)

-- Interaction Command Triggers
local orbitBtn = Instance.new("TextButton")
orbitBtn.Size = UDim2.new(0, 130, 0, 30)
orbitBtn.Position = UDim2.new(0, 175, 0, 55)
orbitBtn.BackgroundColor3 = Color3.fromRGB(35, 55, 95)
orbitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
orbitBtn.Text = "Orbit Selected"
orbitBtn.Font = Enum.Font.SourceSansBold
orbitBtn.TextSize = 13
orbitBtn.Parent = mainFrame

orbitBtn.MouseButton1Click:Connect(function()
    if selectedPart then runOrbit(selectedPart) end
end)

local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 130, 0, 30)
floatBtn.Position = UDim2.new(0, 175, 0, 95)
floatBtn.BackgroundColor3 = Color3.fromRGB(35, 95, 55)
floatBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
floatBtn.Text = "Float Selected"
floatBtn.Font = Enum.Font.SourceSansBold
floatBtn.TextSize = 13
floatBtn.Parent = mainFrame

floatBtn.MouseButton1Click:Connect(function()
    if selectedPart then runFloat(selectedPart) end
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 130, 0, 35)
stopBtn.Position = UDim2.new(0, 175, 0, 170)
stopBtn.BackgroundColor3 = Color3.fromRGB(110, 35, 35)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "Reset All"
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 13
stopBtn.Parent = mainFrame

stopBtn.MouseButton1Click:Connect(clearPreviousClones)
