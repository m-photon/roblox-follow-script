-- Click Follow (Executor Script)
-- Left-click a player to follow 2 studs below them. Click empty space to stop.

if _G.ClickFollowCleanup then
	_G.ClickFollowCleanup()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

local FOLLOW_OFFSET = Vector3.new(0, -2, 0)
local followTarget = nil
local connections = {}
