if _G.ClickFollowCleanup then
	_G.ClickFollowCleanup()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local FOLLOW_OFFSET = Vector3.new(0, -7, 0) -- buried underground so others can't see you
local HOVER_RADIUS = 7
local RAY_DISTANCE = 2000
local CLICK_COOLDOWN = 0.2

local followTarget = nil
local hoverTarget = nil
local hoverHighlight = nil
local followHighlight = nil
local connections = {}
local savedAnchored = nil
local savedTransparency = {}
local lastClickTime = 0

local function track(connection)
	table.insert(connections, connection)
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
	if not instance then
		return nil
	end

	local model = instance:FindFirstAncestorOfClass("Model")
	if not model then
		return nil
	end

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
	if not camera then
		camera = workspace.CurrentCamera
	end
	if not camera then
		return nil
	end

	local mousePos = UserInputService:GetMouseLocation()
	return camera:ViewportPointToRay(mousePos.X, mousePos.Y)
end

local function getPlayerFromRaycast(ray)
	local models = getOtherCharacterModels()
	if #models == 0 then
		return nil
	end

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
	if not ray then
		return getPlayerFromLegacyMouse()
	end

	return getPlayerFromRaycast(ray)
		or getPlayerFromLegacyMouse()
		or getPlayerClosestToRay(ray)
end

local function destroyHighlight(highlight)
	if highlight then
		pcall(function()
			highlight:Destroy()
		end)
	end
end

local function setHoverHighlight(player)
	if hoverTarget == player then
		return
	end

	destroyHighlight(hoverHighlight)
	hoverHighlight = nil
	hoverTarget = player

	if not player then
		return
	end

	local character = getCharacter(player)
	if not character then
		return
	end

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

	if not player then
		return
	end

	local character = getCharacter(player)
	if not character then
		return
	end

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

local function restoreMovement()
	local character = getCharacter(localPlayer)
	local root = getRootPart(character)
	local humanoid = getHumanoid(character)

	if character then
		showCharacter(character)
	end

	if root and savedAnchored ~= nil then
		root.Anchored = savedAnchored
		savedAnchored = nil
	elseif root then
		root.Anchored = false
	end

	if humanoid then
		humanoid.PlatformStand = false
	end
end

local function stopFollowing()
	followTarget = nil
	setFollowHighlight(nil)
	restoreMovement()
end

local function startFollowing(player)
	if followTarget == player then
		return
	end

	if followTarget then
		restoreMovement()
	end

	followTarget = player
	setFollowHighlight(player)

	local character = getCharacter(localPlayer)
	local root = getRootPart(character)
	if root then
		savedAnchored = root.Anchored
	end
	if character then
		hideCharacter(character)
	end

	print("[ClickFollow] Following:", player.Name, "| Press Alt to let go")
end

local function handleClick()
	if tick() - lastClickTime < CLICK_COOLDOWN then
		return
	end
	lastClickTime = tick()

	local clickedPlayer = getPlayerUnderMouse()
	if clickedPlayer then
		startFollowing(clickedPlayer)
	end
end

local function handleRelease()
	if not followTarget then
		return
	end

	stopFollowing()
	print("[ClickFollow] Let go (Alt)")
end

local function hookCharacter(player)
	track(player.CharacterAdded:Connect(function(character)
		track(character.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				if hoverTarget == player then
					setHoverHighlight(nil)
				end
				if followTarget == player then
					stopFollowing()
					print("[ClickFollow] Target left or died")
				end
			end
		end))
	end))

	if player.Character then
		track(player.Character.AncestryChanged:Connect(function(_, parent)
			if parent == nil then
				if hoverTarget == player then
					setHoverHighlight(nil)
				end
				if followTarget == player then
					stopFollowing()
					print("[ClickFollow] Target left or died")
				end
			end
		end))
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
	if not followTarget then
		return
	end

	local myCharacter = getCharacter(localPlayer)
	local targetCharacter = getCharacter(followTarget)
	local myRoot = getRootPart(myCharacter)
	local targetRoot = getRootPart(targetCharacter)
	local humanoid = getHumanoid(myCharacter)

	if not myCharacter or not myRoot or not targetRoot or not humanoid then
		return
	end

	humanoid.PlatformStand = true
	myRoot.Anchored = true

	local targetCFrame = targetRoot.CFrame * CFrame.new(FOLLOW_OFFSET)

	pcall(function()
		myCharacter:PivotTo(targetCFrame)
	end)

	myRoot.CFrame = targetCFrame
	myRoot.AssemblyLinearVelocity = Vector3.zero
	myRoot.AssemblyAngularVelocity = Vector3.zero
end))

track(UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		handleClick()
	elseif input.KeyCode == Enum.KeyCode.LeftAlt or input.KeyCode == Enum.KeyCode.RightAlt then
		handleRelease()
	end
end))

track(Players.PlayerRemoving:Connect(function(player)
	if hoverTarget == player then
		setHoverHighlight(nil)
	end
	if followTarget == player then
		stopFollowing()
		print("[ClickFollow] Target left the game")
	end
end))

track(localPlayer.CharacterAdded:Connect(function()
	stopFollowing()
end))

for _, player in Players:GetPlayers() do
	hookCharacter(player)
end

track(Players.PlayerAdded:Connect(hookCharacter))

_G.ClickFollowCleanup = function()
	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end
	table.clear(connections)

	stopFollowing()
	setHoverHighlight(nil)

	_G.ClickFollowCleanup = nil
	print("[ClickFollow] Unloaded")
end

print("[ClickFollow] Loaded")
print("[ClickFollow] Hover = blue | Following = red | Alt = let go")
print("[ClickFollow] Left click a player to follow underground beneath them")
