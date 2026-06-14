if _G.ClickFollowCleanup then
	_G.ClickFollowCleanup()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local HOVER_RADIUS = 7
local RAY_DISTANCE = 2000
local CLICK_COOLDOWN = 0.2

local followTarget = nil
local hoverTarget = nil
local hoverHighlight = nil
local followHighlight = nil
local connections = {}
local invincibleConnections = {}
local savedAnchored = nil
local savedTransparency = {}
local lastClickTime = 0
local isFlinging = false
local originalCFrame = nil 

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
	if result then
		return getPlayerFromInstance(result.Instance)
	end
	return nil
end

local function getPlayerFromLegacyMouse()
	local ok, target = pcall(function()
		return localPlayer:GetMouse().Target
	end)
	if ok and target then
		local player = getPlayerFromInstance(target)
		if player and player ~= localPlayer then
			return player
		end
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
	if not ray then return getPlayerFromLegacyMouse() end
	return getPlayerFromRaycast(ray) or getPlayerFromLegacyMouse() or getPlayerClosestToRay(ray)
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
		if descendant:IsA("BasePart") then
			savedTransparency[descendant] = descendant.Transparency
			descendant.Transparency = 1
		elseif descendant:IsA("Decal") then
			savedTransparency[descendant] = descendant.Transparency
			descendant.Transparency = 1
		end
	end
end

local function showCharacter(character)
	for instance, transparency in savedTransparency do
		if instance and instance.Parent then
			instance.Transparency = transparency
		end
	end
	table.clear(savedTransparency)
end

local function getGuiParent()
	local ok, result = pcall(function()
		if gethui then return gethui() end
	end)
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
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end))

	track(UserInputService.InputChanged:Connect(function(input)
		if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y
		)
	end))

	track(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
	end))
end

-- Forward declaration
local stopFollowing

local function flingPlayer(player)
	if isFlinging then return end
	
	local character = getCharacter(player)
	local root = getRootPart(character)
	if not character or not root then return end

	isFlinging = true
	print("[ClickFollow] Flinging:", player.Name)

	-- 5 second timer to stop the fling and teleport back
	task.delay(5, function()
		if isFlinging then
			stopFollowing()
			print("[ClickFollow] Fling finished, returned to start.")
		end
	end)
end

local function createMenu()
	if screenGui then return end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ClickFollowGUI"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.Parent = getGuiParent()

	menuFrame = Instance.new("Frame")
	menuFrame.Name = "Menu"
	menuFrame.Size = UDim2.fromOffset(280, 150)
	menuFrame.Position = UDim2.new(0.5, -140, 0.5, -75)
	menuFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	menuFrame.BorderSizePixel = 0
	menuFrame.Visible = false
	menuFrame.Active = true
	menuFrame.Parent = screenGui

	local menuCorner = Instance.new("UICorner")
	menuCorner.CornerRadius = UDim.new(0, 10)
	menuCorner.Parent = menuFrame

	local menuStroke = Instance.new("UIStroke")
	menuStroke.Color = Color3.fromRGB(90, 150, 255)
	menuStroke.Thickness = 1.5
	menuStroke.Parent = menuFrame

	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 34)
	titleBar.BackgroundColor3 = Color3.fromRGB(42, 42, 52)
	titleBar.BorderSizePixel = 0
	titleBar.Active = true
	titleBar.Parent = menuFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = titleBar

	local titleCover = Instance.new("Frame")
	titleCover.Size = UDim2.new(1, 0, 0, 10)
	titleCover.Position = UDim2.new(0, 0, 1, -10)
	titleCover.BackgroundColor3 = titleBar.BackgroundColor3
	titleCover.BorderSizePixel = 0
	titleCover.Parent = titleBar

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -12, 1, 0)
	titleLabel.Position = UDim2.fromOffset(12, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Underground Follow  |  drag top"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 14
	titleLabel.Parent = titleBar

	statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, -20, 0, 44)
	statusLabel.Position = UDim2.fromOffset(10, 42)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "Under: Nobody"
	statusLabel.TextColor3 = Color3.fromRGB(205, 205, 215)
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.TextYAlignment = Enum.TextYAlignment.Top
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 13
	statusLabel.TextWrapped = true
	statusLabel.Parent = menuFrame

	local flingButton = Instance.new("TextButton")
	flingButton.Name = "FlingButton"
	flingButton.Size = UDim2.new(1, -20, 0, 38)
	flingButton.Position = UDim2.fromOffset(10, 96)
	flingButton.BackgroundColor3 = Color3.fromRGB(210, 55, 55)
	flingButton.Text = "FLING TARGET"
	flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	flingButton.Font = Enum.Font.GothamBold
	flingButton.TextSize = 15
	flingButton.BorderSizePixel = 0
	flingButton.AutoButtonColor = true
	flingButton.Parent = menuFrame

	local flingCorner = Instance.new("UICorner")
	flingCorner.CornerRadius = UDim.new(0, 8)
	flingCorner.Parent = flingButton

	makeDraggable(menuFrame, titleBar)

	track(flingButton.MouseButton1Click:Connect(function()
		if followTarget then
			flingPlayer(followTarget)
		end
	end))
end

local function showMenu(player)
	createMenu()
	menuFrame.Visible = true
	statusLabel.Text = "Under: " .. player.Name .. "\nInvincible: ON  |  Alt = let go"
end

local function hideMenu()
	if menuFrame then menuFrame.Visible = false end
end

local function destroyMenu()
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
		menuFrame = nil
		statusLabel = nil
	end
end

local function clearInvincible()
	for _, connection in invincibleConnections do
		connection:Disconnect()
	end
	table.clear(invincibleConnections)
end

local function protectCharacter(character)
	local humanoid = getHumanoid(character)
	if not humanoid then return end

	humanoid.BreakJointsOnDeath = false
	humanoid.Health = humanoid.MaxHealth

	trackInvincible(humanoid.HealthChanged:Connect(function(health)
		if followTarget and health < humanoid.MaxHealth then
			humanoid.Health = humanoid.MaxHealth
		end
	end))

	trackInvincible(humanoid.StateChanged:Connect(function(_, newState)
		if followTarget and newState == Enum.HumanoidStateType.Dead then
			humanoid:ChangeState(Enum.HumanoidStateType.Physics)
			humanoid.Health = humanoid.MaxHealth
		end
	end))
end

local function setInvincible(enabled)
	clearInvincible()
	if not enabled then return end

	local character = getCharacter(localPlayer)
	if character then protectCharacter(character) end

	trackInvincible(localPlayer.CharacterAdded:Connect(function(newCharacter)
		if followTarget then
			task.wait(0.1)
			protectCharacter(newCharacter)
		end
	end))
end

local function restoreMovement()
	local character = getCharacter(localPlayer)
	local root = getRootPart(character)
	local humanoid = getHumanoid(character)

	if character then showCharacter(character) end

	if root and savedAnchored ~= nil then
		root.Anchored = savedAnchored
		savedAnchored = nil
	elseif root then
		root.Anchored = false
	end

	if humanoid then humanoid.PlatformStand = false end
end

-- Implemented stopFollowing
stopFollowing = function()
	local wasFollowing = followTarget ~= nil

	followTarget = nil
	isFlinging = false
	setFollowHighlight(nil)
	setInvincible(false)
	hideMenu()
	restoreMovement()

	local character = getCharacter(localPlayer)
	local root = getRootPart(character)

	-- Teleport back to surface if we were attached to someone
	if wasFollowing and originalCFrame then
		if character then
			character:PivotTo(originalCFrame + Vector3.new(0, 3, 0))
			if root then
				root.AssemblyLinearVelocity = Vector3.zero
				root.AssemblyAngularVelocity = Vector3.zero
			end
		end
		originalCFrame = nil
	end
end

local function startFollowing(player)
	if followTarget == player then return end

	if not followTarget then
		local char = getCharacter(localPlayer)
		local root = getRootPart(char)
		if root then
			originalCFrame = root.CFrame
		end
	end

	if followTarget then
		restoreMovement()
		setInvincible(false)
	end

	isFlinging = false
	followTarget = player
	setFollowHighlight(player)
	setInvincible(true)
	showMenu(player)

	local character = getCharacter(localPlayer)
	local root = getRootPart(character)
	if root then savedAnchored = root.Anchored end
	if character then hideCharacter(character) end

	print("[ClickFollow] Following:", player.Name, "| Alt = let go")
end

local function handleClick()
	if isMouseOverMenu() then return end
	if tick() - lastClickTime < CLICK_COOLDOWN then return end
	lastClickTime = tick()

	local clickedPlayer = getPlayerUnderMouse()
	if clickedPlayer then
		startFollowing(clickedPlayer)
	end
end

local function handleRelease()
	if not followTarget then return end
	stopFollowing()
	print("[ClickFollow] Let go (Alt)")
end

local function hookCharacter(player)
	local function onAncestryChanged(_, parent)
		if parent == nil then
			if hoverTarget == player then setHoverHighlight(nil) end
			if followTarget == player then
				stopFollowing()
				print("[ClickFollow] Target left or died")
			end
		end
	end

	track(player.CharacterAdded:Connect(function(character)
		track(character.AncestryChanged:Connect(onAncestryChanged))
	end))

	if player.Character then
		track(player.Character.AncestryChanged:Connect(onAncestryChanged))
	end
end

track(RunService.RenderStepped:Connect(function()
	local hoveredPlayer = getPlayerUnderMouse()
	if followTarget and hoveredPlayer == followTarget then
		setHoverHighlight(nil)
	else
		setHoverHighlight(hoveredPlayer)
	end
end))

track(RunService.Heartbeat:Connect(function()
	if not followTarget then return end

	local myCharacter = getCharacter(localPlayer)
	local targetCharacter = getCharacter(followTarget)
	local myRoot = getRootPart(myCharacter)
	local targetRoot = getRootPart(targetCharacter)
	local humanoid = getHumanoid(myCharacter)

	if not myCharacter or not myRoot or not targetRoot or not humanoid then return end

	humanoid.PlatformStand = true
	if humanoid.Health < humanoid.MaxHealth then
		humanoid.Health = humanoid.MaxHealth
	end

	if isFlinging then
		-- PATTERN FLING PHYSICS
		myRoot.Anchored = false
		
		-- Noclip everything else so we don't trip on the map while zooming
		for _, part in myCharacter:GetDescendants() do
			if part:IsA("BasePart") and part ~= myRoot then
				part.CanCollide = false
			end
		end

		-- Calculate high-speed mathematical pattern (Tight Figure-8 Sphere)
		local t = tick() * 45 -- Speed multiplier
		local radius = 1.2    -- Distance from center of target
		
		local x = math.sin(t) * radius
		local y = math.cos(t * 1.5) * radius 
		local z = math.cos(t) * radius

		-- Add randomized jitter to make the hits unpredictable
		local jitter = Vector3.new(
			math.random(-2, 2) * 0.1,
			math.random(-2, 2) * 0.1,
			math.random(-2, 2) * 0.1
		)

		-- Teleport through their body in the pattern shape
		myRoot.CFrame = targetRoot.CFrame * CFrame.new(x, y, z) + jitter
		
		-- Force maximum velocity randomly in all directions
		local force = 50000
		myRoot.Velocity = Vector3.new(math.random(-force, force), math.random(-force, force), math.random(-force, force))
		myRoot.RotVelocity = Vector3.new(math.random(-force, force), math.random(-force, force), math.random(-force, force))
	else
		-- PASSIVE FOLLOW UNDERGROUND
		myRoot.Anchored = true
		myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, -7, 0)
		
		myRoot.Velocity = Vector3.zero
		myRoot.RotVelocity = Vector3.zero
	end
end))

track(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton1 then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		handleClick()
	elseif input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		handleRelease()
	end
end))

track(Players.PlayerRemoving:Connect(function(player)
	if hoverTarget == player then setHoverHighlight(nil) end
	if followTarget == player then
		stopFollowing()
		print("[ClickFollow] Target left the game")
	end
end))

track(localPlayer.CharacterAdded:Connect(function() stopFollowing() end))

for _, player in Players:GetPlayers() do hookCharacter(player) end
track(Players.PlayerAdded:Connect(hookCharacter))

_G.ClickFollowCleanup = function()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	table.clear(connections)
	stopFollowing()
	setHoverHighlight(nil)
	destroyMenu()
	_G.ClickFollowCleanup = nil
	print("[ClickFollow] Unloaded")
end

print("[ClickFollow] Loaded")
print("[ClickFollow] Click player = follow | Alt = let go | Menu opens while attached")
