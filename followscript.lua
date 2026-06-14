if _G.ClickFollowCleanup then
	_G.ClickFollowCleanup()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local Debris = game:GetService("Debris")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- Updated for Dynamic Offsets
local DEFAULT_OFFSET = Vector3.new(0, -7, 0)
local FLING_OFFSET = Vector3.new(0, 0, 0)
local currentOffset = DEFAULT_OFFSET

local HOVER_RADIUS = 7
local RAY_DISTANCE = 2000
local CLICK_COOLDOWN = 0.2
local FLING_POWER = 500000

local followTarget = nil
local hoverTarget = nil
local hoverHighlight = nil
local followHighlight = nil
local connections = {}
local invincibleConnections = {}
local savedAnchored = nil
local savedTransparency = {}
local lastClickTime = 0

local screenGui = nil
local menuFrame = nil
local statusLabel = nil

local function track(connection)
	table.insert(connections, connection)
	return connection
end

local function trackInvincible(connection)
	table.insert(invincibleConnections, connection)
	return connection
end

local function getCharacter(player)
	return player and player.Character
end

local function getRootPart(character)
	return character and character:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid(character)
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getPlayerFromInstance(instance)
	if not instance then return nil end
	local model = instance:FindFirstAncestorOfClass("Model")
	if not model then return nil end
	return Players:GetPlayerFromCharacter(model)
end

local function getOtherCharacterModels()
	local models = {}
	for _, player in Players:GetPlayers() do
		if player ~= localPlayer and player.Character then
			table.insert(models, player.Character)
		end
	end
	return models
end

local function getMouseRay()
	if not camera then camera = workspace.CurrentCamera end
	if not camera then return nil end
	local mousePos = UserInputService:GetMouseLocation()
	return camera:ViewportPointToRay(mousePos.X, mousePos.Y)
end

local function getPlayerFromRaycast(ray)
	local models = getOtherCharacterModels()
	if #models == 0 then return nil end
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Include
	params.FilterDescendantsInstances = models
	params.IgnoreWater = true
	local result = workspace:Raycast(ray.Origin, ray.Direction * RAY_DISTANCE, params)
	if result then return getPlayerFromInstance(result.Instance) end
	return nil
end

local function getPlayerFromLegacyMouse()
	local ok, target = pcall(function() return localPlayer:GetMouse().Target end)
	if ok and target then
		local player = getPlayerFromInstance(target)
		if player and player ~= localPlayer then return player end
	end
	return nil
end

local function getPlayerClosestToRay(ray)
	local bestPlayer = nil
	local bestDistance = HOVER_RADIUS
	for _, player in Players:GetPlayers() do
		if player ~= localPlayer then
			local root = getRootPart(getCharacter(player))
			if root then
				local offset = root.Position - ray.Origin
				local depth = offset:Dot(ray.Direction)
				if depth > 0 and depth < RAY_DISTANCE then
					local closestPoint = ray.Origin + ray.Direction * depth
					local distance = (root.Position - closestPoint).Magnitude
					if distance < bestDistance then
						bestDistance = distance
						bestPlayer = player
					end
				end
			end
		end
	end
	return bestPlayer
end

local function getPlayerUnderMouse()
	local ray = getMouseRay()
	return ray and (getPlayerFromRaycast(ray) or getPlayerFromLegacyMouse() or getPlayerClosestToRay(ray)) or getPlayerFromLegacyMouse()
end

local function destroyHighlight(highlight)
	if highlight then pcall(function() highlight:Destroy() end) end
end

local function setHoverHighlight(player)
	if hoverTarget == player then return end
	destroyHighlight(hoverHighlight)
	hoverHighlight = nil
	hoverTarget = player
	if not player then return end
	local character = getCharacter(player)
	if not character then return end
	hoverHighlight = Instance.new("Highlight")
	hoverHighlight.Name = "ClickFollowHover"
	hoverHighlight.Adornee = character
	hoverHighlight.FillColor = Color3.fromRGB(80, 180, 255)
	hoverHighlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	hoverHighlight.FillTransparency = 0.5
	hoverHighlight.OutlineTransparency = 0
	hoverHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hoverHighlight.Parent = character
end

local function setFollowHighlight(player)
	destroyHighlight(followHighlight)
	followHighlight = nil
	if not player then return end
	local character = getCharacter(player)
	if not character then return end
	followHighlight = Instance.new("Highlight")
	followHighlight.Name = "ClickFollowTarget"
	followHighlight.Adornee = character
	followHighlight.FillColor = Color3.fromRGB(255, 60, 60)
	followHighlight.OutlineColor = Color3.fromRGB(255, 255, 80)
	followHighlight.FillTransparency = 0.35
	followHighlight.OutlineTransparency = 0
	followHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	followHighlight.Parent = character
end

local function hideCharacter(character)
	for _, descendant in character:GetDescendants() do
		if descendant:IsA("BasePart") or descendant:IsA("Decal") then
			savedTransparency[descendant] = descendant.Transparency
			descendant.Transparency = 1
		end
	end
end

local function showCharacter(character)
	for instance, transparency in savedTransparency do
		if instance and instance.Parent then instance.Transparency = transparency end
	end
	table.clear(savedTransparency)
end

local function getGuiParent()
	local ok, result = pcall(function() if gethui then return gethui() end end)
	if ok and result then return result end
	return localPlayer:WaitForChild("PlayerGui")
end

local function isMouseOverMenu()
	if not menuFrame or not menuFrame.Visible then return false end
	local mousePos = UserInputService:GetMouseLocation()
	local inset = GuiService:GetGuiInset()
	local adjustedY = mousePos.Y - inset.Y
	local pos = menuFrame.AbsolutePosition
	local size = menuFrame.AbsoluteSize
	return mousePos.X >= pos.X and mousePos.X <= pos.X + size.X and adjustedY >= pos.Y and adjustedY <= pos.Y + size.Y
end

local function makeDraggable(frame, handle)
	local dragging, dragStart, startPos = false, nil, nil
	track(handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging, dragStart, startPos = true, input.Position, frame.Position
		end
	end))
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end))
end

local function claimNetworkPart(part)
	pcall(function() if sethiddenproperty then sethiddenproperty(part, "NetworkOwnershipRule", Enum.NetworkOwnershipRule.Manual) end end)
	pcall(function() if setnetworkowner then setnetworkowner(part, localPlayer) end end)
	pcall(function() part:SetNetworkOwner(localPlayer) end)
end

local function flingPlayer(player)
	local character = getCharacter(player)
	if not character then return end
	local root = getRootPart(character)
	if not root then return end
	for _, part in character:GetDescendants() do
		if part:IsA("BasePart") then
			claimNetworkPart(part)
			part.CanCollide = false
		end
	end
	local flingVelocity = Vector3.new(math.random(-FLING_POWER, FLING_POWER), FLING_POWER * 1.2, math.random(-FLING_POWER, FLING_POWER))
	task.spawn(function()
		for _ = 1, 8 do
			if not root.Parent then break end
			root.AssemblyLinearVelocity = flingVelocity
			root.AssemblyAngularVelocity = Vector3.new(math.random(-8000, 8000), math.random(-8000, 8000), math.random(-8000, 8000))
			task.wait()
		end
	end)
	local bodyVelocity = Instance.new("BodyVelocity")
	bodyVelocity.Name = "ClickFollowFling"
	bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	bodyVelocity.Velocity = flingVelocity
	bodyVelocity.Parent = root
	Debris:AddItem(bodyVelocity, 0.2)
	task.delay(0.25, function()
		if character and character.Parent then
			for _, part in character:GetDescendants() do if part:IsA("BasePart") then part.CanCollide = true end end
		end
	end)
end

local function createMenu()
	if screenGui then return end
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ClickFollowGUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = getGuiParent()
	menuFrame = Instance.new("Frame")
	menuFrame.Size = UDim2.fromOffset(280, 150)
	menuFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
	menuFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	menuFrame.Visible = false
	menuFrame.Parent = screenGui
	-- ... (UI setup elements)
	local flingButton = Instance.new("TextButton")
	flingButton.Name = "FlingButton"
	flingButton.Size = UDim2.new(1, -20, 0, 38)
	flingButton.Position = UDim2.fromOffset(10, 96)
	flingButton.BackgroundColor3 = Color3.fromRGB(210, 55, 55)
	flingButton.Text = "FLING TARGET"
	flingButton.Parent = menuFrame
	
	-- UPDATED BUTTON LOGIC
	track(flingButton.MouseButton1Click:Connect(function()
		if followTarget then
			currentOffset = FLING_OFFSET
			task.wait(0.15)
			flingPlayer(followTarget)
			task.wait(0.3)
			currentOffset = DEFAULT_OFFSET
		end
	end))
end

-- ... [Remaining internal logic functions] ...

-- UPDATED HEARTBEAT
track(RunService.Heartbeat:Connect(function()
	if not followTarget then return end
	local myCharacter = getCharacter(localPlayer)
	local targetCharacter = getCharacter(followTarget)
	local myRoot = getRootPart(myCharacter)
	local targetRoot = getRootPart(targetCharacter)
	local humanoid = getHumanoid(myCharacter)
	if not myCharacter or not myRoot or not targetRoot or not humanoid then return end
	humanoid.PlatformStand = true
	myRoot.Anchored = true
	local targetCFrame = targetRoot.CFrame * CFrame.new(currentOffset)
	pcall(function() myCharacter:PivotTo(targetCFrame) end)
	myRoot.CFrame = targetCFrame
	myRoot.AssemblyLinearVelocity = Vector3.zero
	myRoot.AssemblyAngularVelocity = Vector3.zero
end))

-- (Ensure all other standard functions like stopFollowing and startFollowing remain as they were in your original code)
