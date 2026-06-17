local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- State Management
local IsExecuting = false
local DisguiseActive = true 
local Transformed = false   

-- Audio Configuration
local LOOP_AUDIO_ID = "rbxassetid://99024584540981"
local TV_BURST_AUDIO_1 = "rbxassetid://134093895676420"
local TV_BURST_AUDIO_2 = "rbxassetid://85436077227212"

local GlobalTVModel = nil
local GlobalTVScreen = nil
local loopingSound = nil

-- Function to create the high-detail TV model
local function createExquisiteTV(char)
    local rootPart = char:WaitForChild("HumanoidRootPart", 15)
    local head = char:WaitForChild("Head", 15)
    
    local tvModel = Instance.new("Model")
    tvModel.Name = "TV_DISGUISE"
    tvModel.Parent = char
    GlobalTVModel = tvModel
    
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 1
            if part.Name ~= "HumanoidRootPart" then part.CanCollide = false end
        elseif part:IsA("Accessory") or part:IsA("Clothing") then
            part:Destroy()
        end
    end
    
    local box = Instance.new("Part")
    box.Name = "TV_MainChassis"
    box.Size = Vector3.new(6.5, 5.2, 4.2)
    box.Color = Color3.fromRGB(65, 43, 31)
    box.Material = Enum.Material.Wood
    box.CFrame = head.CFrame
    box.Parent = tvModel
    
    local wBox = Instance.new("Weld", box)
    wBox.Part0 = head; wBox.Part1 = box; wBox.C0 = CFrame.new(0, 0, 0)
    
    local screen = Instance.new("Part")
    screen.Name = "TV_Screen"
    screen.Size = Vector3.new(5.2, 4.0, 0.4)
    screen.Color = Color3.fromRGB(45, 50, 52)
    screen.Material = Enum.Material.Neon
    screen.Parent = tvModel
    GlobalTVScreen = screen
    
    local wScreen = Instance.new("Weld", screen)
    wScreen.Part0 = box; wScreen.Part1 = screen; wScreen.C0 = CFrame.new(0, 0.2, -2.0)
    
    local panel = Instance.new("Part")
    panel.Size = Vector3.new(0.8, 4.0, 0.2)
    panel.Color = Color3.fromRGB(30, 30, 30)
    panel.Material = Enum.Material.SmoothPlastic
    panel.Parent = tvModel
    local wPanel = Instance.new("Weld", panel)
    wPanel.Part0 = box; wPanel.Part1 = panel; wPanel.C0 = CFrame.new(2.5, 0.2, -2.05)
    
    for i = 1, 2 do
        local knob = Instance.new("Part")
        knob.Size = Vector3.new(0.4, 0.4, 0.3)
        knob.Color = Color3.fromRGB(180, 180, 180)
        knob.Material = Enum.Material.Metal
        knob.Parent = tvModel
        local wKnob = Instance.new("Weld", knob)
        wKnob.Part0 = panel; wKnob.Part1 = knob; wKnob.C0 = CFrame.new(0, i == 1 and 1.0 or 0.2, -0.1)
    end
    
    local antBase = Instance.new("Part")
    antBase.Size = Vector3.new(0.6, 0.3, 0.6)
    antBase.Color = Color3.fromRGB(40, 40, 40)
    antBase.Material = Enum.Material.Metal
    antBase.Parent = tvModel
    local wAntBase = Instance.new("Weld", antBase)
    wAntBase.Part0 = box; wAntBase.Part1 = antBase; wAntBase.C0 = CFrame.new(0, 2.7, 0)
    
    for i = -1, 1, 2 do
        local antenna = Instance.new("Part")
        antenna.Size = Vector3.new(0.15, 2.8, 0.15)
        antenna.Color = Color3.fromRGB(150, 150, 150)
        antenna.Material = Enum.Material.Metal
        antenna.Parent = tvModel
        local wAnt = Instance.new("Weld", antenna)
        wAnt.Part0 = antBase; wAnt.Part1 = antenna
        wAnt.C0 = CFrame.new(0.2 * i, 1.3, 0) * CFrame.Angles(0, 0, math.rad(35 * i))
    end
    
    for x = -1, 1, 2 do
        for z = -1, 1, 2 do
            local leg = Instance.new("Part")
            leg.Name = "TV_Leg"
            leg.Size = Vector3.new(0.4, 0.8, 0.4)
            leg.Color = Color3.fromRGB(40, 25, 18)
            leg.Material = Enum.Material.Wood
            leg.Parent = tvModel
            local wLeg = Instance.new("Weld", leg)
            wLeg.Part0 = box; wLeg.Part1 = leg; wLeg.C0 = CFrame.new(2.8 * x, -2.8, 1.8 * z) * CFrame.Angles(math.rad(15 * z), 0, math.rad(-15 * x))
        end
    end
    
    return tvModel, screen
end

-- Monitor proximity, handle countdown, audio stages, and cleanup
local function monitorProximityAndExplode(char, tvModel, tvScreen)
    local rootPart = char:WaitForChild("HumanoidRootPart")
    local proximityDetected = false
    
    while DisguiseActive do
        task.wait(0.3)
        local nearbyFound = false
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (rootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                if dist <= 24 then 
                    nearbyFound = true
                    break
                end
            end
        end
        
        if nearbyFound and not proximityDetected then
            proximityDetected = true
            
            -- Start loop audio
            loopingSound = Instance.new("Sound", char:WaitForChild("Head"))
            loopingSound.SoundId = LOOP_AUDIO_ID
            loopingSound.Looped = true
            loopingSound:Play()
            
            task.delay(20, function()
                if not DisguiseActive then return end
                DisguiseActive = false
                Transformed = true
                
                -- Stop loop audio
                if loopingSound then loopingSound:Stop(); loopingSound:Destroy() end
                
                tvScreen.Color = Color3.fromRGB(255, 0, 0)
                tvScreen.Material = Enum.Material.Glass
                
                -- Play concurrent burst audio
                task.spawn(function()
                    local sound1 = Instance.new("Sound", char:WaitForChild("Head"))
                    sound1.SoundId = TV_BURST_AUDIO_1
                    sound1.Volume = 5
                    sound1:Play()
                    Debris:AddItem(sound1, 7)
                end)
                
                task.spawn(function()
                    local sound2 = Instance.new("Sound", char:WaitForChild("Head"))
                    sound2.SoundId = TV_BURST_AUDIO_2
                    sound2.Volume = 5
                    sound2:Play()
                    Debris:AddItem(sound2, 7)
                end)
                
                task.wait(3)
                
                -- Remove TV
                for _, part in pairs(tvModel:GetChildren()) do
                    if part:IsA("BasePart") then
                        TweenService:Create(part, TweenInfo.new(0.5), {Transparency = 1, CanCollide = false}):Play()
                    end
                end
                
                task.wait(0.5)
                tvModel:Destroy()
                
                -- Disable script to prevent conflicts with subsequent scripts
                script.Disabled = true 
            end)
            break
        end
    end
end

local tvModel, tvScreen = createExquisiteTV(character)
monitorProximityAndExplode(character, tvModel, tvScreen)

-- [[ STARTUP DELAY: 23 SECONDS ]]
print("--- SYSTEM INITIALIZING: WAITING 23 SECONDS TO ACTIVATE ---")
task.wait(23) 

-- [[ COLOSSAL VOID HORROR: MASKED WIRE-BEAST ENGINE (PREDATORY KILL OPTIMIZED) ]] --
-- [[ FEATURES: INWARD NARROW LIMBS, STATIC IDLE, FULL-BODY PREDATORY EXECUTION ]] --

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local IsExecuting = false

-- Audio Asset Configurations
local AUDIO_TRACK_A = "rbxassetid://139784048116231" 
local AUDIO_TRACK_B = "rbxassetid://135193205699915"

-- [[ 1. STABILITY & IMMUNITY LOOP ]]
local function enableSelfStability()
    RunService.Heartbeat:Connect(function()
        local char = player.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = 1e8
            hum.Health = 1e8
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
end

-- [[ 2. EXTRACTION SPLATTER EFFECTS (RED GEOMETRIC DEBRIS BLOCKS) ]]
local function spawnBloodSplatter(position)
    for i = 1, 40 do
        local block = Instance.new("Part")
        block.Size = Vector3.new(math.random(3, 8)/10, math.random(3, 8)/10, math.random(3, 8)/10)
        block.Color = Color3.fromRGB(180, 0, 0)
        block.Material = Enum.Material.Neon
        block.CanCollide = true
        block.Position = position + Vector3.new(math.random(-12, 12)/10, math.random(-12, 12)/10, math.random(-12, 12)/10)
        block.Parent = workspace
        
        block.Velocity = Vector3.new(math.random(-45, 45), math.random(30, 65), math.random(-45, 45))
        block.RotVelocity = Vector3.new(math.random(-35, 35), math.random(-35, 35), math.random(-35, 35))
        
        task.delay(math.random(3, 5), function()
            local t = TweenService:Create(block, TweenInfo.new(0.5), {Transparency = 1, Size = Vector3.zero})
            t:Play()
            t.Completed:Wait()
            block:Destroy()
        end)
    end
end

-- [[ 3. COMPREHENSIVE R6 TRANSFORMATION PIPELINE ]]
local function transformToBeast(char)
    if not char then return end
    
    local hum = char:WaitForChild("Humanoid", 15)
    local rootPart = char:WaitForChild("HumanoidRootPart", 15)
    local head = char:WaitForChild("Head", 15)
    local torso = char:WaitForChild("Torso", 15) 
    
    if not hum or not rootPart or not head or not torso then return end

    if char:FindFirstChild("Animate") then char.Animate:Destroy() end
    for _, v in pairs(head:GetChildren()) do if v:IsA("Decal") then v:Destroy() end end

    -- Turn base body parts into pure matte black void plastic
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "BEAST_ASSET" then
            part.Color = Color3.new(0, 0, 0)
            part.Material = Enum.Material.SmoothPlastic
        elseif part:IsA("Clothing") or part:IsA("ShirtGraphic") or part:IsA("Accessory") then
            part:Destroy()
        end
    end

    -- 【MAXIMUM ULTRA R6 JOINT STRETCH ENGINE】
    pcall(function()
        local leftHip = torso:FindFirstChild("Left Hip")
        local rightHip = torso:FindFirstChild("Right Hip")
        local leftShoulder = torso:FindFirstChild("Left Shoulder")
        local rightShoulder = torso:FindFirstChild("Right Shoulder")
        
        local legStretchOffset = 6.2 
        local armStretchOffset = 4.0 
        
        -- Apply stretched hip logic
        if leftHip then leftHip.C0 = CFrame.new(-1, -legStretchOffset, 0) * CFrame.Angles(0, math.rad(-90), 0) end
        if rightHip then rightHip.C0 = CFrame.new(1, -legStretchOffset, 0) * CFrame.Angles(0, math.rad(90), 0) end
        
        -- 【INWARD NARROW SETUP】
        if leftShoulder then leftShoulder.C0 = CFrame.new(-0.65, 1.2, 0) * CFrame.Angles(0, math.rad(-90), 0) end
        if rightShoulder then rightShoulder.C0 = CFrame.new(0.65, 1.2, 0) * CFrame.Angles(0, math.rad(90), 0) end
        
        local leftLeg = char:FindFirstChild("Left Leg")
        local rightLeg = char:FindFirstChild("Right Leg")
        local leftArm = char:FindFirstChild("Left Arm")
        local rightArm = char:FindFirstChild("Right Arm")
        
        -- Continuous Leg Structures
        if leftLeg and rightLeg then
            local leftLegBridge = Instance.new("Part", char)
            leftLegBridge.Name = "BEAST_ASSET"
            leftLegBridge.Size = Vector3.new(1.05, legStretchOffset, 1.05)
            leftLegBridge.Color = Color3.new(0, 0, 0)
            leftLegBridge.Material = Enum.Material.SmoothPlastic
            leftLegBridge.CanCollide = false
            local wl1 = Instance.new("Weld", leftLegBridge)
            wl1.Part0 = torso; wl1.Part1 = leftLegBridge; wl1.C0 = CFrame.new(-0.5, -legStretchOffset/2, 0)
            
            local rightLegBridge = Instance.new("Part", char)
            rightLegBridge.Name = "BEAST_ASSET"
            rightLegBridge.Size = Vector3.new(1.05, legStretchOffset, 1.05)
            rightLegBridge.Color = Color3.new(0, 0, 0)
            rightLegBridge.Material = Enum.Material.SmoothPlastic
            rightLegBridge.CanCollide = false
            local wl2 = Instance.new("Weld", rightLegBridge)
            wl2.Part0 = torso; wl2.Part1 = rightLegBridge; wl2.C0 = CFrame.new(0.5, -legStretchOffset/2, 0)
        end
        
        -- Physical Extended Arms
        if leftArm and rightArm then
            if leftShoulder then leftShoulder.C0 = leftShoulder.C0 * CFrame.new(0, -armStretchOffset, 0) end
            if rightShoulder then rightShoulder.C0 = rightShoulder.C0 * CFrame.new(0, -armStretchOffset, 0) end

            local leftArmBridge = Instance.new("Part", char)
            leftArmBridge.Name = "BEAST_ASSET"
            leftArmBridge.Size = Vector3.new(1.02, armStretchOffset, 1.02)
            leftArmBridge.Color = Color3.new(0, 0, 0)
            leftArmBridge.Material = Enum.Material.SmoothPlastic
            leftArmBridge.CanCollide = false
            local wa1 = Instance.new("Weld", leftArmBridge)
            wa1.Part0 = torso; wa1.Part1 = leftArmBridge; wa1.C0 = CFrame.new(-0.65, -armStretchOffset/2 + 1.2, 0)
            
            local rightArmBridge = Instance.new("Part", char)
            rightArmBridge.Name = "BEAST_ASSET"
            rightArmBridge.Size = Vector3.new(1.02, armStretchOffset, 1.02)
            rightArmBridge.Color = Color3.new(0, 0, 0)
            rightArmBridge.Material = Enum.Material.SmoothPlastic
            rightArmBridge.CanCollide = false
            local wa2 = Instance.new("Weld", rightArmBridge)
            wa2.Part0 = torso; wa2.Part1 = rightArmBridge; wa2.C0 = CFrame.new(0.65, -armStretchOffset/2 + 1.2, 0)
        end
        
        hum.HipHeight = legStretchOffset + 1.6
        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, legStretchOffset + 1, 0)
    end)

    -- Force R6 neck joint setup
    local neckJoint = torso:FindFirstChild("Neck")
    if neckJoint and neckJoint:IsA("Motor6D") then
        neckJoint.C0 = CFrame.new(0, 4.8, 0) * CFrame.Angles(math.rad(-90), 0, math.rad(180))
    end
    
    -- Generate long structural neck
    local longNeckPart = Instance.new("Part")
    longNeckPart.Name = "BEAST_ASSET"
    longNeckPart.Size = Vector3.new(0.8, 5.0, 0.8)
    longNeckPart.Color = Color3.new(0, 0, 0)
    longNeckPart.Material = Enum.Material.SmoothPlastic
    longNeckPart.CanCollide = false
    longNeckPart.Parent = char
    
    local neckWeld = Instance.new("Weld", longNeckPart)
    neckWeld.Part0 = torso
    neckWeld.Part1 = longNeckPart
    neckWeld.C0 = CFrame.new(0, 2.4, 0)

    -- Mask Definition
    local mask = Instance.new("Part")
    mask.Name = "HORROR_MASK_NODE" 
    mask.Size = Vector3.new(1.3, 1.8, 0.25)
    mask.Color = Color3.fromRGB(245, 245, 245)
    mask.Material = Enum.Material.SmoothPlastic
    mask.CanCollide = false
    mask.Parent = char
    
    local maskWeld = Instance.new("Weld", mask)
    maskWeld.Part0 = head
    maskWeld.Part1 = mask
    maskWeld.C0 = CFrame.new(0, 0, -0.6)

    local function createMaskEyeSlot(side)
        local eyeSlot = Instance.new("Part")
        eyeSlot.Name = "BEAST_ASSET"
        eyeSlot.Size = Vector3.new(0.2, 0.2, 0.1)
        eyeSlot.Color = Color3.fromRGB(15, 15, 15)
        eyeSlot.Material = Enum.Material.Neon
        eyeSlot.CanCollide = false
        eyeSlot.Parent = char
        
        local eyeWeld = Instance.new("Weld", eyeSlot)
        eyeWeld.Part0 = mask
        eyeWeld.Part1 = eyeSlot
        eyeWeld.C0 = CFrame.new(0.26 * side, 0.22, -0.14)
    end
    createMaskEyeSlot(1)
    createMaskEyeSlot(-1)

    -- Generate backend structural wires
    for i = 1, 8 do
        local wire = Instance.new("Part")
        wire.Name = "BEAST_ASSET"
        wire.Size = Vector3.new(0.12, 0.12, math.random(35, 55)/10)
        wire.Color = Color3.fromRGB(20, 20, 20)
        wire.Material = Enum.Material.SmoothPlastic
        wire.CanCollide = false
        wire.Parent = char
        
        local wireWeld = Instance.new("Weld", wire)
        wireWeld.Part0 = torso
        wireWeld.Part1 = wire
        wireWeld.C0 = CFrame.new(math.random(-10, 10)/10, math.random(-5, 15)/10, 0.6) 
            * CFrame.Angles(math.rad(math.random(20, 50)), math.rad(math.random(-30, 30)), math.rad(math.random(-20, 20)))
    end
end

-- [[ 4. R6 ADVANCED PREDATORY SLAUGHTER PIPELINE (FULL-BODY OVERHAUL) ]]
local function executeTargetPlayer(targetModel)
    if IsExecuting or targetModel == player.Character then return end
    
    local myChar = player.Character
    local targetHum = targetModel:FindFirstChildOfClass("Humanoid")
    local targetRoot = targetModel:FindFirstChild("HumanoidRootPart")
    local maskAnchor = myChar:FindFirstChild("HORROR_MASK_NODE")
    
    local torso = myChar:FindFirstChild("Torso")
    local rootPart = myChar:FindFirstChild("HumanoidRootPart")
    local rightShoulder = torso and torso:FindFirstChild("Right Shoulder")
    local leftShoulder = torso and torso:FindFirstChild("Left Shoulder")
    local neckJoint = torso and torso:FindFirstChild("Neck")
    local leftHip = torso and torso:FindFirstChild("Left Hip")
    local rightHip = torso and torso:FindFirstChild("Right Hip")
    
    if not targetHum or not targetRoot or not maskAnchor or not rightShoulder or targetHum.Health <= 0 then return end
    
    IsExecuting = true
    targetHum.PlatformStand = true
    
    -- 備份所有基本關節的原生 C0 姿勢，供處決完畢後還原
    local origRS = rightShoulder.C0
    local origLS = leftShoulder and leftShoulder.C0
    local origNK = neckJoint and neckJoint.C0
    local origLH = leftHip and leftHip.C0
    local origRH = rightHip and rightHip.C0
    local origRootJoint = rootPart and rootPart:FindFirstChild("RootJoint") and rootPart.RootJoint.C0

    -- 音效同步觸發
    task.spawn(function()
        local soundA = Instance.new("Sound", myChar.Head)
        soundA.SoundId = AUDIO_TRACK_A; soundA.Volume = 4.0; soundA:Play()
        game:GetService("Debris"):AddItem(soundA, 6)
    end)
    task.spawn(function()
        local soundB = Instance.new("Sound", targetRoot)
        soundB.SoundId = AUDIO_TRACK_B; soundB.Volume = 4.0; soundB:Play()
        game:GetService("Debris"):AddItem(soundB, 6)
    end)

    -- 【STAGE 1: 掠食者狂暴撲擊 - 全身體聯動傾斜、脖子如蛇般前傾刺出】
    targetRoot.Anchored = true
    
    local pounceTime = 0.14
    local pounceInfo = TweenInfo.new(pounceTime, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    
    -- 右手猛烈伸出
    TweenService:Create(rightShoulder, pounceInfo, {
        C0 = CFrame.new(2.0, 2.5, -5.5) * CFrame.Angles(math.rad(105), math.rad(10), math.rad(-20))
    }):Play()
    -- 左手向後擺動蓄力平衡
    if leftShoulder then
        TweenService:Create(leftShoulder, pounceInfo, {
            C0 = origLS * CFrame.new(-0.2, -0.5, 1.5) * CFrame.Angles(math.rad(-35), 0, math.rad(-10))
        }):Play()
    end
    -- 脖子猛烈向前、向下低伏伸出（展現野獸窺視感）
    if neckJoint then
        TweenService:Create(neckJoint, pounceInfo, {
            C0 = CFrame.new(0, 4.5, -1.8) * CFrame.Angles(math.rad(-65), 0, math.rad(180))
        }):Play()
    end
    -- 雙腳下蹲蓄力
    if leftHip and rightHip then
        TweenService:Create(leftHip, pounceInfo, { C0 = origLH * CFrame.new(0, 0.6, -0.2) * CFrame.Angles(math.rad(-15), 0, 0) }):Play()
        TweenService:Create(rightHip, pounceInfo, { C0 = origRH * CFrame.new(0, 0.6, -0.2) * CFrame.Angles(math.rad(-15), 0, 0) }):Play()
    end
    -- 軀幹本體向前壓低傾斜
    if rootPart and rootPart:FindFirstChild("RootJoint") then
        TweenService:Create(rootPart.RootJoint, pounceInfo, {
            C0 = origRootJoint * CFrame.new(0, 0, -0.5) * CFrame.Angles(math.rad(25), 0, 0)
        }):Play()
    end
    
    targetRoot.CFrame = rootPart.CFrame * CFrame.new(2.0, 4.0, -7.5)
    task.wait(pounceTime)

    -- 【STAGE 2: 拉回面具 & 全身體瘋狂肌肉痙攣 (興奮顫抖)】
    local liftTime = 0.3
    local liftInfo = TweenInfo.new(liftTime, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
    -- 將右手回收到面具正前方
    TweenService:Create(rightShoulder, liftInfo, {
        C0 = CFrame.new(0.2, 3.5, -1.2) * CFrame.Angles(math.rad(115), math.rad(-30), math.rad(-45))
    }):Play()
    -- 脖子往回拉高，死死盯著獵物
    if neckJoint then
        TweenService:Create(neckJoint, liftInfo, {
            C0 = CFrame.new(0, 5.2, -0.5) * CFrame.Angles(math.rad(-100), 0, math.rad(180))
        }):Play()
    end
    -- 身體恢復站立直挺
    if rootPart and rootPart:FindFirstChild("RootJoint") then
        TweenService:Create(rootPart.RootJoint, liftInfo, { C0 = origRootJoint }):Play()
    end
    if leftHip and rightHip then
        TweenService:Create(leftHip, liftInfo, { C0 = origLH }):Play()
        TweenService:Create(rightHip, liftInfo, { C0 = origRH }):Play()
    end

    -- 將獵物強制釘在面具前方
    local faceTween = TweenService:Create(targetRoot, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        CFrame = maskAnchor.CFrame * CFrame.new(0, -0.2, -0.9) * CFrame.Angles(0, math.rad(180), 0)
    })
    faceTween:Play()
    faceTween.Completed:Wait()
    
    local maskPinWeld = Instance.new("Weld", maskAnchor)
    maskPinWeld.Part0 = maskAnchor; maskPinWeld.Part1 = targetRoot
    maskPinWeld.C0 = CFrame.new(0, -0.2, -0.9) * CFrame.Angles(0, math.rad(180), 0)
    targetRoot.Anchored = false

    -- 【掠食者瘋狂高頻顫抖循環（持續約 0.25 秒）】
    local jitterStartTime = tick()
    while tick() - jitterStartTime < 0.25 do
        local jX = math.sin(tick() * 90) * 0.05
        local jY = math.cos(tick() * 85) * 0.05
        local jZ = math.sin(tick() * 95) * 0.05
        
        if rightShoulder then rightShoulder.C0 = rightShoulder.C0 * CFrame.new(jX, jY, jZ) end
        if neckJoint then neckJoint.C0 = neckJoint.C0 * CFrame.Angles(jX*0.2, jY*0.2, jZ*0.2) end
        if leftShoulder then leftShoulder.C0 = leftShoulder.C0 * CFrame.new(jZ, -jX, jY) end
        RunService.Heartbeat:Wait()
    end

    -- 【STAGE 3: 瞬間處決爆體 & 全身體反彈後仰（衝擊波反作用力）】
    local explosionPos = targetRoot.Position
    targetHum.Health = 0
    
    for _, joint in pairs(targetModel:GetDescendants()) do
        if joint:IsA("Motor6D") or joint:IsA("Weld") or joint:IsA("Glue") or joint:IsA("Constraint") then joint:Destroy() end
    end
    for _, part in pairs(targetModel:GetChildren()) do
        if part:IsA("BasePart") then part.Transparency = 1; part.CanCollide = false; part.Anchored = true end
    end
    
    spawnBloodSplatter(explosionPos)
    if maskPinWeld then maskPinWeld:Destroy() end

    -- 全身體強烈向後倒仰，模擬處決瞬間的震撼感
    local recoilInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    if neckJoint then
        TweenService:Create(neckJoint, recoilInfo, { C0 = origNK * CFrame.Angles(math.rad(-40), 0, 0) }):Play()
    end
    if rootPart and rootPart:FindFirstChild("RootJoint") then
        TweenService:Create(rootPart.RootJoint, recoilInfo, { C0 = origRootJoint * CFrame.Angles(math.rad(-15), 0, 0) }):Play()
    end
    if rightShoulder then
        TweenService:Create(rightShoulder, recoilInfo, { C0 = origRS * CFrame.new(0, 0.5, 1) * CFrame.Angles(math.rad(-20), 0, 0) }):Play()
    end
    
    task.wait(0.12) -- 稍微保持後仰姿勢，增加頓挫重量感

    -- 【STAGE 4: 冷酷歸位 - 關節慢慢縮回 narrow 警戒狀態】
    local returnInfo = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    if rightShoulder then TweenService:Create(rightShoulder, returnInfo, { C0 = origRS }):Play() end
    if leftShoulder then TweenService:Create(leftShoulder, returnInfo, { C0 = origLS }):Play() end
    if neckJoint then TweenService:Create(neckJoint, returnInfo, { C0 = origNK }):Play() end
    if leftHip then TweenService:Create(leftHip, returnInfo, { C0 = origLH }):Play() end
    if rightHip then TweenService:Create(rightHip, returnInfo, { C0 = origRH }):Play() end
    if rootPart and rootPart:FindFirstChild("RootJoint") then TweenService:Create(rootPart.RootJoint, returnInfo, { C0 = origRootJoint }):Play() end

    task.wait(0.4)
    IsExecuting = false
end

-- [[ 5. CLICK TARGETING ACTIVATION PIPELINE ]]
mouse.Button1Down:Connect(function()
    if IsExecuting or not player.Character then return end
    local target = mouse.Target
    if target and target.Parent then
        local model = target.Parent
        if model:IsA("Accessory") then model = model.Parent end
        
        if model:IsA("Model") and model:FindFirstChildOfClass("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
            executeTargetPlayer(model)
        end
    end
end)

-- [[ 6. INITIALIZATION CONTROLLERS ]]
enableSelfStability()

player.CharacterAdded:Connect(function(newChar)
    task.wait(0.6) 
    transformToBeast(newChar)
end)

if player.Character then 
    transformToBeast(player.Character) 
end

print("[VOID ENGINE] Predatory Kill System Remastered.")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function InitializeAnimationLoop(character)
    local humanoid = character:WaitForChild("Humanoid")
    local torso = character:WaitForChild("Torso")
    
    local neck = torso:WaitForChild("Neck")
    local rootJoint = character:WaitForChild("HumanoidRootPart"):WaitForChild("RootJoint")
    local rightShoulder = torso:WaitForChild("Right Shoulder")
    local leftShoulder = torso:WaitForChild("Left Shoulder")

    local neckC0 = neck.C0  
    local rootJointC0 = rootJoint.C0  
    local rightShoulderC0 = rightShoulder.C0  
    local leftShoulderC0 = leftShoulder.C0

    if character:FindFirstChild("Animate") then 
        character.Animate.Enabled = false 
    end

    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not character.Parent or humanoid.Health <= 0 then 
            connection:Disconnect()
            return 
        end
        
        local timestamp = tick()
        local moveVelocity = humanoid.MoveDirection.Magnitude
        local isInAir = humanoid.FloorMaterial == Enum.Material.Air

        if isInAir then
            local jumpJitter = math.sin(timestamp * 30) * 0.2
            
            rootJoint.C0 = rootJoint.C0:Lerp(rootJointC0 * CFrame.new(0, 0, jumpJitter) * CFrame.Angles(math.rad(-40), 0, 0), 0.3)
            neck.C0 = neck.C0:Lerp(neckC0 * CFrame.Angles(math.rad(50), 0, 0), 0.3)
            rightShoulder.C0 = rightShoulder.C0:Lerp(rightShoulderC0 * CFrame.Angles(0, 0, math.rad(120)), 0.2)
            leftShoulder.C0 = leftShoulder.C0:Lerp(leftShoulderC0 * CFrame.Angles(0, 0, math.rad(-120)), 0.2)

        elseif moveVelocity > 0.1 then
            local runFrequency = 12
            local runSway = math.sin(timestamp * runFrequency) * 0.1
            local headSway = math.sin(timestamp * (runFrequency / 2)) * 0.2
            
            rootJoint.C0 = rootJoint.C0:Lerp(rootJointC0 * CFrame.new(0, runSway, 0) * CFrame.Angles(math.rad(30), 0, headSway * 0.2), 0.2)
            neck.C0 = neck.C0:Lerp(neckC0 * CFrame.Angles(math.rad(-20), headSway, 0), 0.2)
            rightShoulder.C0 = rightShoulder.C0:Lerp(rightShoulderC0 * CFrame.Angles(math.rad(-15), 0, math.rad(25)), 0.2)
            leftShoulder.C0 = leftShoulder.C0:Lerp(leftShoulderC0 * CFrame.Angles(math.rad(-15), 0, math.rad(-25)), 0.2)

        else
            local horizontalSway = math.sin(timestamp * 1.8) * 0.07
            
            rootJoint.C0 = rootJoint.C0:Lerp(rootJointC0 * CFrame.new(horizontalSway, 0, 0) * CFrame.Angles(math.rad(8), horizontalSway, 0), 0.1)
            neck.C0 = neck.C0:Lerp(neckC0 * CFrame.Angles(math.rad(-12), 0, 0), 0.1)
            rightShoulder.C0 = rightShoulder.C0:Lerp(rightShoulderC0 * CFrame.Angles(0, 0, math.rad(10)), 0.1)
            leftShoulder.C0 = leftShoulder.C0:Lerp(leftShoulderC0 * CFrame.Angles(0, 0, math.rad(-10)), 0.1)
        end
    end)
end

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    local humanoid = newCharacter:WaitForChild("Humanoid")
    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        InitializeAnimationLoop(newCharacter)
    end
end)

if LocalPlayer.Character then
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.RigType == Enum.HumanoidRigType.R6 then
        InitializeAnimationLoop(LocalPlayer.Character)
    end
end

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Verified Void Ambient Audio ID
local AMBIENT_VOID = "rbxassetid://111173652403502" 

-- Global Sound Generator Function (Parented to Character Root)
local function playLocalAmbient(id, volume, playbackSpeed, isAbyssal)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume = volume
    s.PlaybackSpeed = playbackSpeed
    s.Looped = true -- Keeps looping while the character is alive
    s.Parent = RootPart -- Attach to RootPart so it destroys on death
    
    if isAbyssal then
        local ps = Instance.new("PitchShiftSoundEffect", s)
        ps.Octave = 0.5
    end
    
    s:Play()
    return s
end

-- Initialize and play the ambient audio for the current life
local bgm = playLocalAmbient(AMBIENT_VOID, 5, 0.15, true)
bgm.Name = "CharacterAmbientVoid"

-- Optional: Monitor to ensure it stays playing while alive
task.spawn(function()
    while Character.Parent and RootPart.Parent do
        if bgm and not bgm.IsPlaying then
            bgm:Play()
        end
        task.wait(2)
    end
end)

print("Audio System: Active for current life. Will automatically clear on respawn.")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isTracking = false

-- Configuration Parameters
local STICKY_DURATION = 2.0 -- Sticky tracking duration (in seconds)
local FOLLOW_OFFSET = Vector3.new(0, 0, -2.5) -- Distance offset (2.5 studs directly in front)

-- Function to handle high-precision sticky tracking
local function startStickyFollow(targetRoot)
    if isTracking then return end
    isTracking = true
    
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    if not myRoot then 
        isTracking = false 
        return 
    end
    
    -- Temporarily disable character collision to prevent physics clipping/fling glitches
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Use RenderStepped for engine-level CFrame locking (unshakeable update rate)
    local followConnection
    followConnection = RunService.RenderStepped:Connect(function()
        if not targetRoot or not targetRoot.Parent or not myRoot or not isTracking then
            if followConnection then followConnection:Disconnect() end
            return
        end
        
        -- Calculate target position with offset and force character orientation
        local targetCFrame = targetRoot.CFrame
        local targetPosWithOffset = targetCFrame:ToWorldSpace(CFrame.new(FOLLOW_OFFSET))
        
        -- Lock CFrame position and face the target directly
        myRoot.CFrame = CFrame.new(targetPosWithOffset.Position, targetRoot.Position)
        myRoot.Velocity = Vector3.zero -- Reset velocity to nullify physics inertia dragging
    end)
    
    -- Release target player after 2 seconds and restore physics state
    task.delay(STICKY_DURATION, function()
        isTracking = false
        if followConnection then followConnection:Disconnect() end
        
        -- Restore character part collisions back to normal mechanics
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        print("[TRACKER] 2 seconds elapsed. Target released.")
    end)
end

-- local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isTracking = false

-- Configuration Parameters
local STICKY_DURATION = 2.0 -- Sticky tracking duration (in seconds)
local FOLLOW_OFFSET = Vector3.new(0, 0, -2.5) -- Distance offset (2.5 studs directly in front)
local BURIAL_DEPTH = 150 -- How deep underground to send the target player

-- Function to handle high-precision sticky tracking and burial
local function startStickyFollow(targetRoot, targetModel)
    if isTracking then return end
    isTracking = true
    
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        isTracking = false 
        return 
    end
    
    -- Temporarily disable your own character collision to prevent physics clipping/fling glitches
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Use RenderStepped for engine-level CFrame locking (unshakeable update rate)
    local followConnection
    followConnection = RunService.RenderStepped:Connect(function()
        if not targetRoot or not targetRoot.Parent or not myRoot or not isTracking then
            if followConnection then followConnection:Disconnect() end
            return
        end
        
        -- Calculate target position with offset and force character orientation
        local targetCFrame = targetRoot.CFrame
        local targetPosWithOffset = targetCFrame:ToWorldSpace(CFrame.new(FOLLOW_OFFSET))
        
        -- Lock CFrame position and face the target directly
        myRoot.CFrame = CFrame.new(targetPosWithOffset.Position, targetRoot.Position)
        myRoot.Velocity = Vector3.zero -- Reset velocity to nullify physics inertia dragging
    end)
    
    -- Release target player after 2 seconds, then bury them deep underground
    task.delay(STICKY_DURATION, function()
        isTracking = false
        if followConnection then followConnection:Disconnect() end
        
        -- Restore your own character part collisions back to normal mechanics
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        -- Execute the deep burial mechanic if the target is still valid
        if targetRoot and targetRoot.Parent then
            print("[TRACKER] 2 seconds elapsed. Sending target to the abyss.")
            
            -- Force drop their CFrame deep underground
            targetRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -BURIAL_DEPTH, 0)
            targetRoot.Velocity = Vector3.zero
            
            -- Anchor their primary components so they cannot jump or walk back up easily
            for _, part in pairs(targetModel:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = true
                end
            end
        end
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isTracking = false

-- Configuration Parameters
local STICKY_DURATION = 2.0 -- Sticky tracking duration (in seconds)
local FOLLOW_OFFSET = Vector3.new(0, 0, -2.5) -- Distance offset (2.5 studs directly in front)
local BURIAL_DEPTH = 180 -- How deep underground to send the target player (increased for safety)

-- Function to handle high-precision sticky tracking and full entity burial
local function startStickyFollow(targetRoot, targetModel)
    if isTracking then return end
    isTracking = true
    
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        isTracking = false 
        return 
    end
    
    -- Temporarily disable your own character collision to prevent physics clipping/fling glitches
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Use RenderStepped for engine-level CFrame locking (unshakeable update rate)
    local followConnection
    followConnection = RunService.RenderStepped:Connect(function()
        if not targetRoot or not targetRoot.Parent or not myRoot or not isTracking then
            if followConnection then followConnection:Disconnect() end
            return
        end
        
        -- Calculate target position with offset and force character orientation
        local targetCFrame = targetRoot.CFrame
        local targetPosWithOffset = targetCFrame:ToWorldSpace(CFrame.new(FOLLOW_OFFSET))
        
        -- Lock CFrame position and face the target directly
        myRoot.CFrame = CFrame.new(targetPosWithOffset.Position, targetRoot.Position)
        myRoot.Velocity = Vector3.zero -- Reset velocity to nullify physics inertia dragging
    end)
    
    -- Release target player after 2 seconds, then bury EVERY PART associated with them
    task.delay(STICKY_DURATION, function()
        isTracking = false
        if followConnection then followConnection:Disconnect() end
        
        -- Restore your own character part collisions back to normal mechanics
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        -- Execute the total entity burial mechanic if the target model still exists
        if targetModel and targetModel.Parent then
            print("[TRACKER] 2 seconds elapsed. Interring total target entity in the abyss.")
            
            local targetHum = targetModel:FindFirstChildOfClass("Humanoid")
            if targetHum then targetHum.PlatformStand = true end -- Force them to drop flat

            -- [FULL ENTITY BURIAL PIPELINE]
            -- Iterate through EVERY single object recursively inside the target character model
            for _, item in pairs(targetModel:GetDescendants()) do
                if item:IsA("BasePart") then
                    -- 1. Un-anchor momentarily to break initial physics constraints
                    item.Anchored = false
                    
                    -- 2. Recalculate their CFrame deep underground relative to their current spot
                    -- We multiply the whole CFrame so orientation is preserved.
                    item.CFrame = item.CFrame * CFrame.new(0, -BURIAL_DEPTH, 0)
                    
                    -- 3. Reset any inertia and then re-anchor firmly to trap them
                    item.Velocity = Vector3.zero
                    item.RotVelocity = Vector3.zero
                    item.Anchored = true 
                end
            end
        end
    end)
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isTracking = false

-- Configuration Parameters
local STICKY_DURATION = 2.0 -- Sticky tracking duration (in seconds)
local FOLLOW_OFFSET = Vector3.new(0, 0, -2.5) -- Distance offset (2.5 studs directly in front)
local BURIAL_DEPTH = 180 -- How deep underground to send the target player (increased for safety)

-- Function to handle high-precision sticky tracking and full entity burial
local function startStickyFollow(targetRoot, targetModel)
    if isTracking then return end
    isTracking = true
    
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        isTracking = false 
        return 
    end
    
    -- Temporarily disable your own character collision to prevent physics clipping/fling glitches
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Use RenderStepped for engine-level CFrame locking (unshakeable update rate)
    local followConnection
    followConnection = RunService.RenderStepped:Connect(function()
        if not targetRoot or not targetRoot.Parent or not myRoot or not isTracking then
            if followConnection then followConnection:Disconnect() end
            return
        end
        
        -- Calculate target position with offset and force character orientation
        local targetCFrame = targetRoot.CFrame
        local targetPosWithOffset = targetCFrame:ToWorldSpace(CFrame.new(FOLLOW_OFFSET))
        
        -- Lock CFrame position and face the target directly
        myRoot.CFrame = CFrame.new(targetPosWithOffset.Position, targetRoot.Position)
        myRoot.Velocity = Vector3.zero -- Reset velocity to nullify physics inertia dragging
    end)
    
    -- Release target player after 2 seconds, then bury EVERY PART associated with them
    task.delay(STICKY_DURATION, function()
        isTracking = false
        if followConnection then followConnection:Disconnect() end
        
        -- Restore your own character part collisions back to normal mechanics
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
        
        -- Execute the total entity burial mechanic if the target model still exists
        if targetModel and targetModel.Parent then
            print("[TRACKER] 2 seconds elapsed. Interring total target entity in the abyss.")
            
            local targetHum = targetModel:FindFirstChildOfClass("Humanoid")
            if targetHum then targetHum.PlatformStand = true end -- Force them to drop flat

            -- [FULL ENTITY BURIAL PIPELINE]
            -- Iterate through EVERY single object recursively inside the target character model
            for _, item in pairs(targetModel:GetDescendants()) do
                if item:IsA("BasePart") then
                    -- 1. Un-anchor momentarily to break initial physics constraints
                    item.Anchored = false
                    
                    -- 2. Recalculate their CFrame deep underground relative to their current spot
                    -- We multiply the whole CFrame so orientation is preserved.
                    item.CFrame = item.CFrame * CFrame.new(0, -BURIAL_DEPTH, 0)
                    
                    -- 3. Reset any inertia and then re-anchor firmly to trap them
                    item.Velocity = Vector3.zero
                    item.RotVelocity = Vector3.zero
                    item.Anchored = true 
                end
            end
        end
    end)
end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

-- Configuration Parameters
local BOX_SIZE = 60 -- The interior boundary size around you (60x60x60 studs area)
local WALL_THICKNESS = 4 -- Heavy duty structural density to absorb high-velocity impacts

local function createSolidVoidShield(char)
    local rootPart = char:WaitForChild("HumanoidRootPart", 15)
    if not rootPart then return end

    -- Create a hidden container for the barrier system
    local shieldFolder = Instance.new("Folder")
    shieldFolder.Name = "ANTI_VOID_SHIELD_SYSTEM"
    shieldFolder.Parent = char

    -- Helper table to manage the 6 protective boundary walls
    local walls = {}

    local function buildWall(name, size)
        local wall = Instance.new("Part")
        wall.Name = name
        wall.Size = size
        wall.Transparency = 1 -- 1 = Completely invisible so it doesn't block your view
        wall.Anchored = true
        wall.CanCollide = true
        wall.Material = Enum.Material.ForceField
        wall.Parent = shieldFolder
        table.insert(walls, wall)
        return wall
    end

    -- Construct the 6-sided secure containment vault around the character
    local floor  = buildWall("Shield_Floor",  Vector3.new(BOX_SIZE, WALL_THICKNESS, BOX_SIZE))
    local ceiling = buildWall("Shield_Ceiling", Vector3.new(BOX_SIZE, WALL_THICKNESS, BOX_SIZE))
    local wallFront = buildWall("Shield_Front", Vector3.new(BOX_SIZE, BOX_SIZE, WALL_THICKNESS))
    local wallBack  = buildWall("Shield_Back",  Vector3.new(BOX_SIZE, BOX_SIZE, WALL_THICKNESS))
    local wallLeft  = buildWall("Shield_Left",  Vector3.new(WALL_THICKNESS, BOX_SIZE, BOX_SIZE))
    local wallRight = buildWall("Shield_Right", Vector3.new(WALL_THICKNESS, BOX_SIZE, BOX_SIZE))

    -- High-speed RenderStepped matrix loop to glue the protective walls onto your coordinate frame
    local calculationConnection
    calculationConnection = RunService.RenderStepped:Connect(function()
        if not char.Parent or not rootPart or not rootPart.Parent then
            if calculationConnection then calculationConnection:Disconnect() end
            shieldFolder:Destroy()
            return
        end

        local currentPos = rootPart.Position
        local halfSize = BOX_SIZE / 2

        -- Lock the physical positions of the absolute solid grid relative to your character core
        floor.CFrame   = CFrame.new(currentPos.X, currentPos.Y - halfSize - (WALL_THICKNESS / 2), currentPos.Z)
        ceiling.CFrame = CFrame.new(currentPos.X, currentPos.Y + halfSize + (WALL_THICKNESS / 2), currentPos.Z)
        
        wallFront.CFrame = CFrame.new(currentPos.X, currentPos.Y, currentPos.Z - halfSize - (WALL_THICKNESS / 2))
        wallBack.CFrame  = CFrame.new(currentPos.X, currentPos.Y, currentPos.Z + halfSize + (WALL_THICKNESS / 2))
        
        wallLeft.CFrame  = CFrame.new(currentPos.X - halfSize - (WALL_THICKNESS / 2), currentPos.Y, currentPos.Z)
        wallRight.CFrame = CFrame.new(currentPos.X + halfSize + (WALL_THICKNESS / 2), currentPos.Y, currentPos.Z)
    end)
end

-- Initialize shield system across lifecycle execution pipelines
player.CharacterAdded:Connect(function(newChar)
    task.wait(0.5)
    createSolidVoidShield(newChar)
end)

if player.Character then
    createSolidVoidShield(player.Character)
end

print("[SOLID VOID SHIELD] Active cage setup initialized. Sky, ground, and sides fully reinforced.")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local isTracking = false

-- Configuration Parameters
local STICKY_DURATION = 2.0 -- Sticky tracking duration (in seconds)
local FOLLOW_OFFSET = Vector3.new(0, 0, -2.5) -- Distance offset (2.5 studs directly in front)
local BURIAL_DEPTH = 180 -- How deep underground to send the target player (increased for safety)

-- Function to handle high-precision sticky tracking and full entity burial
local function startStickyFollow(targetRoot, targetModel)
    if isTracking then return end
    isTracking = true
    
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    
    if not myRoot then 
        isTracking = false 
        return 
    end
    
    -- Temporarily disable your own character collision to prevent physics clipping/fling glitches
    for _, part in pairs(myChar:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Use RenderStepped for engine-level CFrame locking (unshakeable update rate)
    local followConnection
    followConnection = RunService.RenderStepped:Connect(function()
        if not targetRoot or not targetRoot.Parent or not myRoot or not isTracking then
            if followConnection then followConnection:Disconnect() end
            return
        end
        
        -- Calculate target position with offset and force character orientation
        local targetCFrame = targetRoot.CFrame
        local targetPosWithOffset = targetCFrame:ToWorldSpace(CFrame.new(FOLLOW_OFFSET))
        
        -- Lock CFrame position and face the target directly
        myRoot.CFrame = CFrame.new(targetPosWithOffset.Position, targetRoot.Position)
        myRoot.Velocity = Vector3.zero -- Reset velocity to nullify physics inertia dragging
    end)
    
    -- Release target player after 2 seconds, then bury EVERY PART associated with them
    task.delay(STICKY_DURATION, function()
        isTracking = false
        if followConnection then followConnection:Disconnect() end
        
        -- Restore your own character part collisions back to normal mechanics
        if player.Character then
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    pa... (3 KB left)
