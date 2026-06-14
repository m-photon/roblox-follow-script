--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[[
    MALEVOLENT SHRINE SCRIPT - GET TOOL
    Game ID: 18918471876
    Get Malevolent shrine
    Created by: Redsky-Catl0l
]]

local player = game.Players.LocalPlayer
local targetGameId = "18918471876"
local currentGameId = tostring(game.GameId or game.PlaceId or "")

print("[Redsky-Catl0l] ========================================")
print("[Redsky-Catl0l] MALEVOLENT SHRINE SCRIPT LOADED")
print("[Redsky-Catl0l] Target Game ID: " .. targetGameId)
print("[Redsky-Catl0l] Current Game ID: " .. currentGameId)
print("[Redsky-Catl0l] Target Path: Player.Backpack['Malevolent Shrine']")
print("[Redsky-Catl0l] ========================================")

-- Membuat ScreenGui utama
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MalevolentShrineGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 10, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(255, 80, 120)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, -100)
mainFrame.Size = UDim2.new(0, 320, 0, 200)
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local border = Instance.new("UIStroke")
border.Parent = mainFrame
border.Color = Color3.fromRGB(255, 80, 120)
border.Thickness = 1.5
border.Transparency = 0.3

-- Title
local title = Instance.new("TextLabel")
title.Parent = mainFrame
title.BackgroundColor3 = Color3.fromRGB(40, 15, 45)
title.BackgroundTransparency = 0.3
title.Size = UDim2.new(1, 0, 0, 45)
title.Position = UDim2.new(0, 0, 0, 0)
title.Font = Enum.Font.GothamBold
title.Text = "[ MALEVOLENT SHRINE ]"
title.TextColor3 = Color3.fromRGB(255, 80, 120)
title.TextSize = 16

-- Game ID info
local gameIdInfo = Instance.new("TextLabel")
gameIdInfo.Parent = mainFrame
gameIdInfo.BackgroundTransparency = 1
gameIdInfo.Size = UDim2.new(1, 0, 0, 20)
gameIdInfo.Position = UDim2.new(0, 0, 0.2, 0)
gameIdInfo.Font = Enum.Font.Code
gameIdInfo.Text = "[ GAME ID: 18918471876 ]"
gameIdInfo.TextColor3 = Color3.fromRGB(255, 180, 100)
gameIdInfo.TextSize = 10

-- Subtitle
local subtitle = Instance.new("TextLabel")
subtitle.Parent = mainFrame
subtitle.BackgroundTransparency = 1
subtitle.Size = UDim2.new(1, 0, 0, 20)
subtitle.Position = UDim2.new(0, 0, 0.27, 0)
subtitle.Font = Enum.Font.Gotham
subtitle.Text = "Domain Expansion: Fukuma Mizushi"
subtitle.TextColor3 = Color3.fromRGB(200, 100, 150)
subtitle.TextSize = 10

-- Main Button: Get Malevolent Shrine
local getButton = Instance.new("TextButton")
getButton.Name = "GetButton"
getButton.Parent = mainFrame
getButton.BackgroundColor3 = Color3.fromRGB(100, 30, 80)
getButton.BackgroundTransparency = 0.2
getButton.Position = UDim2.new(0.1, 0, 0.4, 0)
getButton.Size = UDim2.new(0.8, 0, 0.3, 0)
getButton.Font = Enum.Font.GothamBold
getButton.Text = "GET MALEVOLENT SHRINE"
getButton.TextColor3 = Color3.fromRGB(255, 100, 150)
getButton.TextSize = 13

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = getButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Parent = getButton
btnStroke.Color = Color3.fromRGB(255, 80, 120)
btnStroke.Thickness = 1

-- Status Label
local statusLabel = Instance.new("TextLabel")
statusLabel.Parent = mainFrame
statusLabel.BackgroundTransparency = 1
statusLabel.Size = UDim2.new(1, 0, 0, 25)
statusLabel.Position = UDim2.new(0, 0, 0.74, 0)
statusLabel.Font = Enum.Font.Gotham
statusLabel.Text = "Status: Ready"
statusLabel.TextColor3 = Color3.fromRGB(150, 100, 140)
statusLabel.TextSize = 11

-- Thank You Label
local thankYouLabel = Instance.new("TextLabel")
thankYouLabel.Parent = mainFrame
thankYouLabel.BackgroundTransparency = 1
thankYouLabel.Size = UDim2.new(1, 0, 0, 20)
thankYouLabel.Position = UDim2.new(0, 0, 0.85, 0)
thankYouLabel.Font = Enum.Font.Gotham
thankYouLabel.Text = "ty for using the script :)"
thankYouLabel.TextColor3 = Color3.fromRGB(180, 120, 160)
thankYouLabel.TextSize = 10

-- Creator Label
local creatorLabel = Instance.new("TextLabel")
creatorLabel.Parent = mainFrame
creatorLabel.BackgroundTransparency = 1
creatorLabel.Size = UDim2.new(1, 0, 0, 20)
creatorLabel.Position = UDim2.new(0, 0, 0.93, 0)
creatorLabel.Font = Enum.Font.Gotham
creatorLabel.Text = "Created by: Redsky-Catl0l"
creatorLabel.TextColor3 = Color3.fromRGB(120, 70, 100)
creatorLabel.TextSize = 9

-- ========== GET MALEVOLENT SHRINE FUNCTION ==========
local function getMalevolentShrine()
    print("[Redsky-Catl0l] Attempting to add Malevolent Shrine to backpack...")
    
    statusLabel.Text = "Status: Searching for Malevolent Shrine..."
    statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
    
    local success = false
    local toolAdded = false
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    -- Method 1: Langsung tambahkan ke backpack
    if backpack then
        -- Cek apakah tool sudah ada
        local existingTool = backpack:FindFirstChild("Malevolent Shrine")
        if existingTool then
            print("[Redsky-Catl0l] Malevolent Shrine already exists in backpack!")
            statusLabel.Text = "Status: Malevolent Shrine already in backpack! ✓"
            statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            success = true
            toolAdded = true
        else
            -- Cari tool di berbagai lokasi
            local tool = nil
            
            -- Cari di ReplicatedStorage
            local replicatedStorage = game:GetService("ReplicatedStorage")
            if replicatedStorage then
                tool = replicatedStorage:FindFirstChild("Malevolent Shrine")
                if not tool then
                    tool = replicatedStorage:FindFirstChild("MalevolentShrine")
                end
                if not tool then
                    for _, child in pairs(replicatedStorage:GetChildren()) do
                        if child:IsA("Tool") and (child.Name:lower():find("malevolent") or child.Name:lower():find("shrine")) then
                            tool = child
                            break
                        end
                    end
                end
            end
            
            -- Cari di ServerStorage
            if not tool then
                local serverStorage = game:GetService("ServerStorage")
                if serverStorage then
                    tool = serverStorage:FindFirstChild("Malevolent Shrine")
                    if not tool then
                        tool = serverStorage:FindFirstChild("MalevolentShrine")
                    end
                end
            end
            
            -- Cari di Workspace
            if not tool then
                tool = workspace:FindFirstChild("Malevolent Shrine")
                if not tool then
                    tool = workspace:FindFirstChild("MalevolentShrine")
                end
            end
            
            -- Cari di Lighting
            if not tool then
                local lighting = game:GetService("Lighting")
                tool = lighting:FindFirstChild("Malevolent Shrine")
            end
            
            -- Clone tool jika ditemukan
            if tool and tool:IsA("Tool") then
                local newTool = tool:Clone()
                newTool.Parent = backpack
                print("[Redsky-Catl0l] ✓ Malevolent Shrine added to backpack from: " .. tool:GetFullName())
                toolAdded = true
                success = true
            else
                -- Method 2: Buat tool baru jika tidak ditemukan
                print("[Redsky-Catl0l] Malevolent Shrine tool not found, creating new tool...")
                
                local newTool = Instance.new("Tool")
                newTool.Name = "Malevolent Shrine"
                newTool.RequiresHandle = false
                newTool.CanBeDropped = true
                
                -- Tool icon (opsional)
                local toolIcon = Instance.new("StringValue")
                toolIcon.Name = "ToolIcon"
                toolIcon.Value = "rbxassetid://123456789"
                toolIcon.Parent = newTool
                
                -- Tool description
                local toolDesc = Instance.new("StringValue")
                toolDesc.Name = "Description"
                toolDesc.Value = "Domain Expansion: Malevolent Shrine - Fukuma Mizushi"
                toolDesc.Parent = newTool
                
                newTool.Parent = backpack
                print("[Redsky-Catl0l] ✓ Created new Malevolent Shrine tool in backpack")
                toolAdded = true
                success = true
            end
        end
    else
        print("[Redsky-Catl0l] Backpack not found!")
    end
    
    -- Method 3: Equip langsung ke karakter jika backpack tidak ada
    if not toolAdded and character then
        local tool = character:FindFirstChild("Malevolent Shrine")
        if not tool then
            tool = character:FindFirstChild("MalevolentShrine")
        end
        
        if not tool then
            -- Buat tool dan pasang ke karakter
            local newTool = Instance.new("Tool")
            newTool.Name = "Malevolent Shrine"
            newTool.RequiresHandle = false
            newTool.Parent = character
            print("[Redsky-Catl0l] ✓ Malevolent Shrine equipped directly to character")
            toolAdded = true
            success = true
        else
            print("[Redsky-Catl0l] Malevolent Shrine already equipped!")
            success = true
        end
    end
    
    -- Method 4: Coba fire remote untuk mendapatkan tool
    pcall(function()
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local remoteEvents = {
            "GiveTool", "GetTool", "EquipItem", "PurchaseItem",
            "MalevolentShrine", "DomainExpansion", "GetShrine"
        }
        
        for _, remoteName in pairs(remoteEvents) do
            local remote = replicatedStorage:FindFirstChild(remoteName)
            if remote and remote:IsA("RemoteEvent") then
                remote:FireServer("Malevolent Shrine")
                remote:FireServer("MalevolentShrine")
                remote:FireServer(player, "Malevolent Shrine")
                print("[Redsky-Catl0l] Fired remote: " .. remoteName)
            end
        end
    end)
    
    -- Update status dan UI
    if success then
        statusLabel.Text = "Status: Malevolent Shrine Obtained! ✓"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        getButton.BackgroundColor3 = Color3.fromRGB(80, 50, 100)
        getButton.Text = "✓ MALEVOLENT SHRINE OBTAINED ✓"
        
        -- Efek kedip sukses
        for i = 1, 3 do
            border.Thickness = 3
            wait(0.05)
            border.Thickness = 1.5
            wait(0.05)
        end
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Malevolent Shrine - Redsky-Catl0l";
            Text = "Malevolent Shrine has been added to your backpack! Domain Expansion: Fukuma Mizushi";
            Duration = 5;
        })
        
        print("[Redsky-Catl0l] ========================================")
        print("[Redsky-Catl0l] MALEVOLENT SHRINE SUCCESSFULLY ADDED!")
        print("[Redsky-Catl0l] Location: Player.Backpack['Malevolent Shrine']")
        print("[Redsky-Catl0l] ========================================")
    else
        statusLabel.Text = "Status: Failed - Tool not found in game"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        getButton.BackgroundColor3 = Color3.fromRGB(100, 30, 80)
        
        game.StarterGui:SetCore("SendNotification", {
            Title = "Malevolent Shrine - Redsky-Catl0l";
            Text = "Failed to find Malevolent Shrine tool. Make sure you're in the correct game (ID: 18918471876)";
            Duration = 4;
        })
    end
    
    return success
end

-- ========== BUTTON CLICK ==========
getButton.MouseButton1Click:Connect(function()
    -- Animation
    getButton.BackgroundTransparency = 0.4
    wait(0.1)
    getButton.BackgroundTransparency = 0.2
    
    getMalevolentShrine()
end)

-- Hover effects
getButton.MouseEnter:Connect(function()
    getButton.BackgroundColor3 = Color3.fromRGB(130, 50, 110)
    btnStroke.Thickness = 2
end)

getButton.MouseLeave:Connect(function()
    if statusLabel.Text:find("OBTAINED") then
        getButton.BackgroundColor3 = Color3.fromRGB(80, 50, 100)
    else
        getButton.BackgroundColor3 = Color3.fromRGB(100, 30, 80)
    end
    btnStroke.Thickness = 1
end)

-- Draggable
local dragging = false
local dragStart
local frameStartPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        frameStartPos = mainFrame.Position
    end
end)

mainFrame.InputEnded:Connect(function()
    dragging = false
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(frameStartPos.X.Scale, frameStartPos.X.Offset + delta.X, frameStartPos.Y.Scale, frameStartPos.Y.Offset + delta.Y)
    end
end)

-- ========== INITIALIZATION ==========
game.StarterGui:SetCore("SendNotification", {
    Title = "Malevolent Shrine - Redsky-Catl0l";
    Text = "Script loaded! Click GET MALEVOLENT SHRINE to add the tool to your backpack.";
    Duration = 4;
})

print("[Redsky-Catl0l] ========================================")
print("[Redsky-Catl0l] MALEVOLENT SHRINE SCRIPT READY")
print("[Redsky-Catl0l] Game ID: 18918471876")
print("[Redsky-Catl0l] Target: Player.Backpack['Malevolent Shrine']")
print("[Redsky-Catl0l] ty for using the script :)")
print("[Redsky-Catl0l] ========================================")
