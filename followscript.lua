--[[
    Dynamic Accessory Action System (Orbit, Hit, & Throw)
    Recommended File Name: init.lua
    
    Description: 
    An all-in-one script for GitHub. 
    Controls: 'C' to Orbit, 'Z' to Melee Hit, 'X' to Throw Accessory.
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local AccessorySystem = {
    Radius = 4,
    Speed = 5,
    HitDamage = 30,    -- Melee damage
    ThrowDamage = 40,  -- Projectile damage
    ThrowSpeed = 100,  -- How fast the accessory flies
    ActiveOrbits = {},
    ActiveActions = {} -- Tracks current animation locks
}

-- Initialize Network Routing
local AccessoryEvent = ReplicatedStorage:FindFirstChild("AccessoryEvent")
if not AccessoryEvent then
    AccessoryEvent = Instance.new("RemoteEvent")
    AccessoryEvent.Name = "AccessoryEvent"
    AccessoryEvent.Parent = ReplicatedStorage
end

-- ==========================================
-- CLIENT INFRASTRUCTURE SOURCE CODE
-- ==========================================
local ClientScriptSource = [[
    local UserInputService = game:GetService("UserInputService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local AccessoryEvent = ReplicatedStorage:WaitForChild("AccessoryEvent")
    
    local isOrbiting = false
    
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.C then
            isOrbiting = not isOrbiting
            AccessoryEvent:FireServer("Orbit", isOrbiting)
        elseif input.KeyCode == Enum.KeyCode.Z then
            AccessoryEvent:FireServer("Hit")
        elseif input.KeyCode == Enum.KeyCode.X then
            AccessoryEvent:FireServer("Throw")
        end
    end)
]]

-- ==========================================
-- PROJECTILE THROW ENGINE LOGIC
-- ==========================================
function AccessorySystem.PerformThrow(character, accessory)
    if AccessorySystem.ActiveActions[character] then return end
    AccessorySystem.ActiveActions[character] = true

    -- Drop out of orbit if currently spinning
    if AccessorySystem.ActiveOrbits[character] then
        AccessorySystem.StopOrbit(character)
    end

    local handle = accessory:FindFirstChild("Handle")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
    
    if not handle or not humanoid or not torso then 
        AccessorySystem.ActiveActions[character] = nil
        return 
    end

    -- 1. Play a quick overhead throwing animation frame
    local animInstance = Instance.new("Animation")
    animInstance.AnimationId = "rbxassetid://507765644" -- Public Roblox throw asset track
    local animationTrack = humanoid:LoadAnimation(animInstance)
    animationTrack:Play()

    -- Hide the actual accessory on the player's back while it is "thrown"
    handle.Transparency = 1

    -- 2. Construct the physical projectile clone
    local projectile = handle:Clone()
    projectile.Transparency = 0
    projectile.CanCollide = false
    projectile.Anchored = false
    projectile.CFrame = torso.CFrame * CFrame.new(0, 0, -2) -- Spawn slightly in front of player
    projectile.Parent = workspace

    -- Strip out original welds from the clone so it can move freely
    for _, child in ipairs(projectile:GetChildren()) do
        if child:IsA("Weld") or child:IsA("ManualWeld") or child:IsA("AccessoryWeld") then
            child:Destroy()
        end
    end

    -- 3. Apply linear velocity to drive it straight forward
    local linearVelocity = Instance.new("LinearVelocity")
    local attachment = Instance.new("Attachment")
    attachment.Parent = projectile
    
    linearVelocity.MaxForce = math.huge
    linearVelocity.VectorVelocity = torso.CFrame.LookVector * AccessorySystem.ThrowSpeed
    linearVelocity.Attachment0 = attachment
    linearVelocity.Parent = projectile

    -- Apply a rotational spin force to make it look like a boomerang or flying disc
    local angularVelocity = Instance.new("AngularVelocity")
    angularVelocity.MaxTorque = math.huge
    angularVelocity.AngularVelocity = Vector3.new(0, 20, 0) -- Spin horizontally
    angularVelocity.Attachment0 = attachment
    angularVelocity.Parent = projectile

    -- 4. Hitbox Collision Logic
    local targetsHit = {}
    local hitConnection
    
    hitConnection = projectile.Touched:Connect(function(otherPart)
        local targetCharacter = otherPart.Parent
        if targetCharacter and targetCharacter:IsA("Model") and targetCharacter ~= character then
            local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and not targetsHit[targetCharacter] then
                targetsHit[targetCharacter] = true
                targetHumanoid:TakeDamage(AccessorySystem.ThrowDamage)
                
                -- Destroy projectile instantly upon impacting an enemy
                if hitConnection then hitConnection:Disconnect() end
                projectile:Destroy()
            end
        end
    end)

    -- Automatically clean up projectile after 3 seconds if it misses everything
    Debris:AddItem(projectile, 3)

    -- 5. Return accessory to back after animation sequence ends
    task.delay(0.5, function()
        if handle and character:IsDescendantOf(workspace) then
            handle.Transparency = 0
        end
        animInstance:Destroy()
        AccessorySystem.ActiveActions[character] = nil
    end)
end

-- ==========================================
-- MELEE HIT ENGINE LOGIC
-- ==========================================
function AccessorySystem.PerformHit(character, accessory)
    if AccessorySystem.ActiveActions[character] then return end 
    AccessorySystem.ActiveActions[character] = true

    if AccessorySystem.ActiveOrbits[character] then
        AccessorySystem.StopOrbit(character)
    end

    local handle = accessory:FindFirstChild("Handle")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rightHand = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    
    if not handle or not humanoid or not rightHand or not torso then 
        AccessorySystem.ActiveActions[character] = nil
        return 
    end

    local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("ManualWeld") or handle:FindFirstChild("AccessoryWeld")
    
    if weld then
        weld.Part0 = rightHand
        weld.C0 = CFrame.new(0, -1, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    end

    local animInstance = Instance.new("Animation")
    animInstance.AnimationId = "rbxassetid://507765066" 
    local animationTrack = humanoid:LoadAnimation(animInstance)
    animationTrack:Play()

    local hitConnection
    local targetsHit = {}

    hitConnection = handle.Touched:Connect(function(otherPart)
        local targetCharacter = otherPart.Parent
        if targetCharacter and targetCharacter:IsA("Model") and targetCharacter ~= character then
            local targetHumanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and not targetsHit[targetCharacter] then
                targetsHit[targetCharacter] = true
                targetHumanoid:TakeDamage(AccessorySystem.HitDamage)
            end
        end
    end)

    animationTrack.Stopped:Connect(function()
        if hitConnection then hitConnection:Disconnect() end
        animInstance:Destroy()

        if weld and character:IsDescendantOf(workspace) then
            weld.Part0 = torso
            weld.C0 = CFrame.new(0, 0, 0.7)
        end

        AccessorySystem.ActiveActions[character] = nil
    end)
end

-- ==========================================
-- ORBIT ENGINE LOGIC
-- ==========================================
function AccessorySystem.StartOrbit(character, accessory)
    if AccessorySystem.ActiveActions[character] then return end 

    local handle = accessory:FindFirstChild("Handle")
    if not handle then return end

    local torso = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if not torso then return end

    local weld = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("ManualWeld") or handle:FindFirstChild("AccessoryWeld")
    if weld then
        weld.Part1 = nil 
    end

    handle.Anchored = true 
    local angle = 0

    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not character or not character:IsDescendantOf(workspace) or not torso then
            connection:Disconnect()
            return
        end

        angle = angle + (AccessorySystem.Speed * dt)

        local offsetX = math.cos(angle) * AccessorySystem.Radius
        local offsetZ = math.sin(angle) * AccessorySystem.Radius
        
        handle.CFrame = torso.CFrame * CFrame.new(offsetX, 1, offsetZ) * CFrame.Angles(0, angle, 0)
    end)

    AccessorySystem.ActiveOrbits[character] = {
        Connection = connection,
        Weld = weld,
        Handle = handle,
        TargetTorso = torso
    }
end

function AccessorySystem.StopOrbit(character)
    local session = AccessorySystem.ActiveOrbits[character]
    if not session then return end

    if session.Connection then session.Connection:Disconnect() end

    if session.Handle and session.Weld then
        session.Handle.Anchored = false
        session.Weld.Part1 = session.TargetTorso
    end

    AccessorySystem.ActiveOrbits[character] = nil
end

-- ==========================================
-- INITIALIZATION & HOOKS
-- ==========================================
local function SetupPlayerInput(player)
    player.CharacterAdded:Connect(function(character)
        local clientScript = Instance.new("LocalScript")
        clientScript.Name = "AccessoryInputHandler"
        clientScript.Source = ClientScriptSource
        clientScript.Parent = character
    end)
    
    if player.Character then
        local clientScript = Instance.new("LocalScript")
        clientScript.Name = "AccessoryInputHandler"
        clientScript.Source = ClientScriptSource
        clientScript.Parent = player.Character
    end
end

AccessoryEvent.OnServerEvent:Connect(function(player, actionType, state)
    local character = player.Character
    if not character then return end

    local targetAccessory = nil
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") and (child.Name:lower():match("back") or child:FindFirstChild("Handle")) then
            targetAccessory = child
            break
        end
    end

    if not targetAccessory then return end

    if actionType == "Orbit" then
        if state == true then
            AccessorySystem.StartOrbit(character, targetAccessory)
        else
            AccessorySystem.StopOrbit(character)
        end
    elseif actionType == "Hit" then
        AccessorySystem.PerformHit(character, targetAccessory)
    elseif actionType == "Throw" then
        AccessorySystem.PerformThrow(character, targetAccessory)
    end
end)

Players.PlayerAdded:Connect(SetupPlayerInput)
for _, player in ipairs(Players:GetPlayers()) do
    SetupPlayerInput(player)
end

return AccessorySystem
