local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

-- 1. Locate the Local Player and Character context cleanly
local player = Players.LocalPlayer
if not player then
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
local humanoid = character:FindFirstChildOfClass("Humanoid")
local playerGui = player:WaitForChild("PlayerGui", 5)

-- Global engine tracking states
local activeConnection = nil
local activeClone = nil
local originalPart = nil
local creepyWalkConnection = nil
local creepyWalkActive = false

-- Locate joints for procedural animation
local joints = {}
local function cacheJoints()
    local r15Torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("LowerTorso")
    if character:FindFirstChild("Torso") then -- R6 Structure
        joints.Root = character.HumanoidRootPart:FindFirstChild("RootJoint")
        joints.LeftLeg = character.Torso:FindFirstChild("Left Hip")
        joints.RightLeg = character.Torso:FindFirstChild("Right Hip")
        joints.LeftArm = character.Torso:FindFirstChild("Left Shoulder")
        joints.RightArm = character.Torso:FindFirstChild("Right Shoulder")
        joints.Neck = character.Torso:FindFirstChild("Neck")
        joints.Type = "R6"
    elseif r15Torso then -- R15 Structure
        joints.Root = character.LowerTorso:FindFirstChild("Root")
        joints.LeftLeg = character.LeftUpperLeg:FindFirstChild("LeftHip")
        joints.RightLeg = character.RightUpperLeg:FindFirstChild("RightHip")
        joints.LeftArm = character.LeftUpperArm:FindFirstChild("LeftShoulder")
        joints.RightArm = character.RightUpperArm:FindFirstChild("RightShoulder")
        joints.Neck = character.Head:FindFirstChild("Neck")
        joints.Type = "R15"
    end
end
cacheJoints()

-- Save original joint angles so we can restore them perfectly
local originalC0s = {}
for name, joint in pairs(joints) do
    if typeof(joint) == "Instance" and joint:IsA("Motor6D") then
        originalC0s[name] = joint.C0
    end
end

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

local function restoreJoints()
    if creepyWalkConnection then creepyWalkConnection:Disconnect(); creepyWalkConnection = nil end
    for name, joint in pairs(joints) do
        if typeof(joint) == "Instance" and joint:IsA("Motor6D") and originalC0s[name] then
            joint.C0 = originalC0s[name]
        end
    end
end

-- ==========================================
-- ANIMATION CALCULATIONS
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

-- PROCEDURAL CREEPY LIMP ENGINE
local function toggleCreepyWalk()
    if creepyWalkActive then
        creepyWalkActive = false
        restoreJoints()
        return
    end

    creepyWalkActive = true
    cacheJoints() -- Ensure joints are targeted correctly
    
    local timer = 0
    creepyWalkConnection = RunService.RenderStepped:Connect(function(dt)
        if not character or not character.Parent or not humanoid then
            restoreJoints()
            return
        end

        -- Check if character is moving or stationary
        local isMoving = humanoid.MoveDirection.Magnitude > 01
        local speedMultiplier = isMoving and 1.5 or 0.3
        timer = timer + (dt * 5 * speedMultiplier)

        -- Base creepy configuration variables
        local wave = math.sin(timer)
        local absoluteWave = math.abs(math.sin(timer))

        if joints.Type == "R15" or joints.Type == "R6" then
            -- 1. Unnatural Head Tilt
            if joints.Neck and originalC0s.Neck then
                joints.Neck.C0 = originalC0s.Neck * CFrame.Angles(math.rad(15 + wave * 5), 0, math.rad(10))
            end

            -- 2. Asymmetric Limping Legs
            if joints.LeftLeg and originalC0s.LeftLeg then
                if isMoving then
                    -- The left leg drops down heavily and drags behind (The Limp)
                    joints.LeftLeg.C0 = originalC0s.LeftLeg * CFrame.new(0, -absoluteWave * 0.4, -wave * 0.3) * CFrame.Angles(math.rad(-10 + wave * 20), 0, 0)
                else
                    joints.LeftLeg.C0 = originalC0s.LeftLeg * CFrame.Angles(math.rad(-5), 0, math.rad(-5))
                end
            end

            if joints.RightLeg and originalC0s.RightLeg then
                if isMoving then
                    -- Right leg functions with a faster, jerky recovery step to overcompensate
                    joints.RightLeg.C0 = originalC0s.RightLeg * CFrame.new(0, 0, wave * 0.5) * CFrame.Angles(math.rad(wave * -25), 0, 0)
                else
                    joints.RightLeg.C0 = originalC0s.RightLeg * CFrame.Angles(0, 0, math.rad(5))
                end
            end

            -- 3. Broken, Dragging Arms
            if joints.LeftArm and originalC0s.LeftArm then
                -- Left arm is broken completely down and twisted inward
                joints.LeftArm.C0 = originalC0s.LeftArm * CFrame.Angles(math.rad(-15 + wave * 2), math.rad(-20), math.rad(-30))
            end

            if joints.RightArm and originalC0s.RightArm then
                -- Right arm twitches up and down weirdly
                joints.RightArm.C0 = originalC0s.RightArm * CFrame.Angles(math.rad(10 + wave * 15), 0, math.rad(15))
            end
            
            -- 4. Torso slouching forward/downward during walking stride
            if joints.Root and originalC0s.Root then
                if isMoving then
                    joints.Root.C0 = originalC0s.Root * CFrame.new(0, -absoluteWave * 0.3, 0) * CFrame.Angles(math.rad(12 + wave * 3), 0, 0)
                else
                    joints.Root.C0 = originalC0s.Root * CFrame.Angles(math.rad(5), 0, 0)
                end
            end
        end
    end)
end

-- ==========================================
-- SCREEN-CENTERED DRAGGABLE UI SCREEN
-- ==========================================
if playerGui:FindFirstChild("AccessoryCentricUI") then
    playerGui.AccessoryCentricUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AccessoryCentricUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 320, 0, 275) -- Height extended to accommodate animation button
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -137)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Manual Dragging Engine Implementation
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
titleLabel.Text = "Accessory & Anim Controller"
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
    restoreJoints()
    screenGui:Destroy()
end)

-- Scrolling Panel for Accessory Names
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(0, 145, 0, 185)
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

-- NEW: Procedural Animation Control Toggle Button
local animPackBtn = Instance.new("TextButton")
animPackBtn.Size = UDim2.new(0, 130, 0, 30)
animPackBtn.Position = UDim2.new(0, 175, 0, 135)
animPackBtn.BackgroundColor3 = Color3.fromRGB(85, 45, 115)
animPackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
animPackBtn.Text = "Creepy Walk: OFF"
animPackBtn.Font = Enum.Font.SourceSansBold
animPackBtn.TextSize = 13
animPackBtn.Parent = mainFrame

animPackBtn.MouseButton1Click:Connect(function()
    toggleCreepyWalk()
    if creepyWalkActive then
        animPackBtn.Text = "Creepy Walk: ON"
        animPackBtn.BackgroundColor3 = Color3.fromRGB(130, 50, 180)
    else
        animPackBtn.Text = "Creepy Walk: OFF"
        animPackBtn.BackgroundColor3 = Color3.fromRGB(85, 45, 115)
    end
end)

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0, 130, 0, 35)
stopBtn.Position = UDim2.new(0, 175, 0, 205)
stopBtn.BackgroundColor3 = Color3.fromRGB(110, 35, 35)
stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
stopBtn.Text = "Reset All"
stopBtn.Font = Enum.Font.SourceSansBold
stopBtn.TextSize = 13
stopBtn.Parent = mainFrame

stopBtn.MouseButton1Click:Connect(function()
    clearPreviousClones()
    if creepyWalkActive then
        toggleCreepyWalk()
        animPackBtn.Text = "Creepy Walk: OFF"
        animPackBtn.BackgroundColor3 = Color3.fromRGB(85, 45, 115)
    end
end)
