--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
--[=[
 d888b  db    db d888888b      .d888b.      db      db    db  .d8b.  
88' Y8b 88    88   `88'        VP  `8D      88      88    88 d8' `8b 
88      88    88    88            odD'      88      88    88 88ooo88 
88  ooo 88    88    88          .88'        88      88    88 88~~~88 
88. ~8~ 88b  d88   .88.        j88.         88booo. 88b  d88 88   88    @uniquadev
 Y888P  ~Y8888P' Y888888P      888888D      Y88888P ~Y8888P' YP   YP  CONVERTER 

designed using localmaze gui creator
]=]

-- Instances: 36 | Scripts: 16 | Modules: 0 | Tags: 0
local LMG2L = {};

-- Players.khimzo8171.PlayerGui.ScreenGui
LMG2L["ScreenGui_1"] = Instance.new("ScreenGui", game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"));
LMG2L["ScreenGui_1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Sibling;


-- Players.khimzo8171.PlayerGui.ScreenGui.Frame
LMG2L["Frame_2"] = Instance.new("Frame", LMG2L["ScreenGui_1"]);
LMG2L["Frame_2"]["BorderSizePixel"] = 0;
LMG2L["Frame_2"]["BackgroundColor3"] = Color3.fromRGB(0, 8, 255);
LMG2L["Frame_2"]["Size"] = UDim2.new(0, 478, 0, 286);
LMG2L["Frame_2"]["Position"] = UDim2.new(0, 168, 0, 6);


-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextLabel
LMG2L["TextLabel_3"] = Instance.new("TextLabel", LMG2L["Frame_2"]);
LMG2L["TextLabel_3"]["BorderSizePixel"] = 0;
LMG2L["TextLabel_3"]["TextSize"] = 24;
LMG2L["TextLabel_3"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextLabel_3"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextLabel_3"]["Size"] = UDim2.new(0, 470, 0, 32);
LMG2L["TextLabel_3"]["Text"] = [[Virus GUI F3X]];
LMG2L["TextLabel_3"]["Position"] = UDim2.new(0, 4, 0, 4);


-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.UIDragDetector
LMG2L["UIDragDetector_4"] = Instance.new("UIDragDetector", LMG2L["Frame_2"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_5"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_5"]["BorderSizePixel"] = 0;
LMG2L["TextButton_5"]["TextSize"] = 18;
LMG2L["TextButton_5"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_5"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_5"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_5"]["Text"] = [[decal]];
LMG2L["TextButton_5"]["Position"] = UDim2.new(0, 4, 0, 38);



LMG2L["LocalScript_6"] = Instance.new("LocalScript", LMG2L["TextButton_5"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_7"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_7"]["BorderSizePixel"] = 0;
LMG2L["TextButton_7"]["TextSize"] = 18;
LMG2L["TextButton_7"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_7"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_7"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_7"]["Text"] = [[skybox]];
LMG2L["TextButton_7"]["Position"] = UDim2.new(0, 122, 0, 38);



LMG2L["LocalScript_8"] = Instance.new("LocalScript", LMG2L["TextButton_7"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_9"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_9"]["BorderSizePixel"] = 0;
LMG2L["TextButton_9"]["TextSize"] = 18;
LMG2L["TextButton_9"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_9"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_9"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_9"]["Text"] = [[spin skybox]];
LMG2L["TextButton_9"]["Position"] = UDim2.new(0, 240, 0, 38);



LMG2L["LocalScript_a"] = Instance.new("LocalScript", LMG2L["TextButton_9"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_b"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_b"]["BorderSizePixel"] = 0;
LMG2L["TextButton_b"]["TextSize"] = 18;
LMG2L["TextButton_b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_b"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_b"]["Text"] = [[btools/f3x]];
LMG2L["TextButton_b"]["Position"] = UDim2.new(0, 358, 0, 38);



LMG2L["LocalScript_c"] = Instance.new("LocalScript", LMG2L["TextButton_b"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_d"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_d"]["BorderSizePixel"] = 0;
LMG2L["TextButton_d"]["TextSize"] = 18;
LMG2L["TextButton_d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_d"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_d"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_d"]["Text"] = [[title]];
LMG2L["TextButton_d"]["Position"] = UDim2.new(0, 4, 0, 82);



LMG2L["LocalScript_e"] = Instance.new("LocalScript", LMG2L["TextButton_d"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_f"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_f"]["BorderSizePixel"] = 0;
LMG2L["TextButton_f"]["TextSize"] = 18;
LMG2L["TextButton_f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_f"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_f"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_f"]["Text"] = [[avatar all]];
LMG2L["TextButton_f"]["Position"] = UDim2.new(0, 122, 0, 82);



LMG2L["LocalScript_10"] = Instance.new("LocalScript", LMG2L["TextButton_f"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_11"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_11"]["BorderSizePixel"] = 0;
LMG2L["TextButton_11"]["TextSize"] = 18;
LMG2L["TextButton_11"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_11"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_11"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_11"]["Text"] = [[disco]];
LMG2L["TextButton_11"]["Position"] = UDim2.new(0, 240, 0, 82);



LMG2L["LocalScript_12"] = Instance.new("LocalScript", LMG2L["TextButton_11"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_13"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_13"]["BorderSizePixel"] = 0;
LMG2L["TextButton_13"]["TextSize"] = 18;
LMG2L["TextButton_13"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_13"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_13"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_13"]["Text"] = [[music]];
LMG2L["TextButton_13"]["Position"] = UDim2.new(0, 358, 0, 82);



LMG2L["LocalScript_14"] = Instance.new("LocalScript", LMG2L["TextButton_13"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_15"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_15"]["BorderSizePixel"] = 0;
LMG2L["TextButton_15"]["TextSize"] = 18;
LMG2L["TextButton_15"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_15"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_15"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_15"]["Text"] = [[kill other]];
LMG2L["TextButton_15"]["Position"] = UDim2.new(0, 4, 0, 126);



LMG2L["LocalScript_16"] = Instance.new("LocalScript", LMG2L["TextButton_15"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_17"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_17"]["BorderSizePixel"] = 0;
LMG2L["TextButton_17"]["TextSize"] = 18;
LMG2L["TextButton_17"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_17"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_17"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_17"]["Text"] = [[title]];
LMG2L["TextButton_17"]["Position"] = UDim2.new(0, 122, 0, 126);



LMG2L["LocalScript_18"] = Instance.new("LocalScript", LMG2L["TextButton_17"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_19"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_19"]["BorderSizePixel"] = 0;
LMG2L["TextButton_19"]["TextSize"] = 18;
LMG2L["TextButton_19"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_19"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_19"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_19"]["Text"] = [[alert]];
LMG2L["TextButton_19"]["Position"] = UDim2.new(0, 240, 0, 126);



LMG2L["LocalScript_1a"] = Instance.new("LocalScript", LMG2L["TextButton_19"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_1b"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_1b"]["BorderSizePixel"] = 0;
LMG2L["TextButton_1b"]["TextSize"] = 18;
LMG2L["TextButton_1b"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_1b"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_1b"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_1b"]["Text"] = [[hint]];
LMG2L["TextButton_1b"]["Position"] = UDim2.new(0, 358, 0, 126);



LMG2L["LocalScript_1c"] = Instance.new("LocalScript", LMG2L["TextButton_1b"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_1d"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_1d"]["BorderSizePixel"] = 0;
LMG2L["TextButton_1d"]["TextSize"] = 18;
LMG2L["TextButton_1d"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_1d"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_1d"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_1d"]["Text"] = [[message]];
LMG2L["TextButton_1d"]["Position"] = UDim2.new(0, 4, 0, 170);



LMG2L["LocalScript_1e"] = Instance.new("LocalScript", LMG2L["TextButton_1d"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_1f"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_1f"]["BorderSizePixel"] = 0;
LMG2L["TextButton_1f"]["TextSize"] = 18;
LMG2L["TextButton_1f"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_1f"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_1f"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_1f"]["Text"] = [[teleport all]];
LMG2L["TextButton_1f"]["Position"] = UDim2.new(0, 122, 0, 170);



LMG2L["LocalScript_20"] = Instance.new("LocalScript", LMG2L["TextButton_1f"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_21"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_21"]["BorderSizePixel"] = 0;
LMG2L["TextButton_21"]["TextSize"] = 18;
LMG2L["TextButton_21"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_21"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_21"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_21"]["Text"] = [[cmdbar2]];
LMG2L["TextButton_21"]["Position"] = UDim2.new(0, 240, 0, 170);



LMG2L["LocalScript_22"] = Instance.new("LocalScript", LMG2L["TextButton_21"]);



-- Players.khimzo8171.PlayerGui.ScreenGui.Frame.TextButton
LMG2L["TextButton_23"] = Instance.new("TextButton", LMG2L["Frame_2"]);
LMG2L["TextButton_23"]["BorderSizePixel"] = 0;
LMG2L["TextButton_23"]["TextSize"] = 18;
LMG2L["TextButton_23"]["BackgroundColor3"] = Color3.fromRGB(255, 255, 255);
LMG2L["TextButton_23"]["FontFace"] = Font.new([[rbxasset://fonts/families/Arial.json]], Enum.FontWeight.Bold, Enum.FontStyle.Normal);
LMG2L["TextButton_23"]["Size"] = UDim2.new(0, 116, 0, 42);
LMG2L["TextButton_23"]["Text"] = [[r6]];
LMG2L["TextButton_23"]["Position"] = UDim2.new(0, 358, 0, 170);



LMG2L["LocalScript_24"] = Instance.new("LocalScript", LMG2L["TextButton_23"]);




local function C_6()
	local script = LMG2L["LocalScript_6"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local player = game.Players.LocalPlayer	
			local char = player.Character	
			local tool	
			for i,v in player:GetDescendants() do	
				if v.Name == "SyncAPI" then	
					tool = v.Parent	
				end	
			end	
			for i,v in game.ReplicatedStorage:GetDescendants() do	
				if v.Name == "SyncAPI" then	
					tool = v.Parent	
				end	
			end	
			--craaa	
			remote = tool.SyncAPI.ServerEndpoint	
			function _(args)	
				remote:InvokeServer(unpack(args))	
			end	
			function SetCollision(part,boolean)	
				local args = {	
					[1] = "SyncCollision",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["CanCollide"] = boolean	
						}	
					}	
				}	
				_(args)	
			end	
			function SetAnchor(boolean,part)	
				local args = {	
					[1] = "SyncAnchor",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Anchored"] = boolean	
						}	
					}	
				}	
				_(args)	
			end	
			function CreatePart(cf,parent)	
				local args = {	
					[1] = "CreatePart",	
					[2] = "Normal",	
					[3] = cf,	
					[4] = parent	
				}	
				_(args)	
			end	
			function DestroyPart(part)	
				local args = {	
					[1] = "Remove",	
					[2] = {	
						[1] = part	
					}	
				}	
				_(args)	
			end	
			function MovePart(part,cf)	
				local args = {	
					[1] = "SyncMove",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["CFrame"] = cf	
						}	
					}	
				}	
				_(args)	
			end	
			function Resize(part,size,cf)	
				local args = {	
					[1] = "SyncResize",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["CFrame"] = cf,	
							["Size"] = size	
						}	
					}	
				}	
				_(args)	
			end	
			function AddMesh(part)	
				local args = {	
					[1] = "CreateMeshes",	
					[2] = {	
						[1] = {	
							["Part"] = part	
						}	
					}	
				}	
				_(args)	
			end	
			
			function SetMesh(part,meshid)	
				local args = {	
					[1] = "SyncMesh",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["MeshId"] = "rbxassetid://"..meshid	
						}	
					}	
				}	
				_(args)	
			end	
			function SetTexture(part, texid)	
				local args = {	
					[1] = "SyncMesh",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["TextureId"] = "rbxassetid://"..texid	
						}	
					}	
				}	
				_(args)	
			end	
			function SetName(part, stringg)	
				local args = {	
					[1] = "SetName",	
					[2] = {	
						[1] = part	
					},	
					[3] = stringg	
				}	
			
				_(args)	
			end	
			function MeshResize(part,size)	
				local args = {	
					[1] = "SyncMesh",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Scale"] = size	
						}	
					}	
				}	
				_(args)	
			end	
			function Weld(part1, part2,lead)	
				local args = {	
					[1] = "CreateWelds",	
					[2] = {	
						[1] = part1,	
						[2] = part2	
					},	
					[3] = lead	
				}	
				_(args)	
			
			end	
			function SetLocked(part,boolean)	
				local args = {	
					[1] = "SetLocked",	
					[2] = {	
						[1] = part	
					},	
					[3] = boolean	
				}	
				_(args)	
			end	
			function SetTrans(part,int)	
				local args = {	
					[1] = "SyncMaterial",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Transparency"] = int	
						}	
					}	
				}	
				_(args)	
			end	
			function CreateSpotlight(part)	
				local args = {	
					[1] = "CreateLights",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["LightType"] = "SpotLight"	
						}	
					}	
				}	
				_(args)	
			end	
			function SyncLighting(part,brightness)	
				local args = {	
					[1] = "SyncLighting",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["LightType"] = "SpotLight",	
							["Brightness"] = brightness	
						}	
					}	
				}	
				_(args)	
			end	
			function Color(part,color)	
				local args = {	
					[1] = "SyncColor",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Color"] = color --[[Color3]],	
							["UnionColoring"] = false	
						}	
					}	
				}	
				_(args)	
			end	
			function SpawnDecal(part,side)	
				local args = {	
					[1] = "CreateTextures",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Face"] = side,	
							["TextureType"] = "Decal"	
						}	
					}	
				}	
			
				_(args)	
			end	
			function AddDecal(part,asset,side)	
				local args = {	
					[1] = "SyncTexture",	
					[2] = {	
						[1] = {	
							["Part"] = part,	
							["Face"] = side,	
							["TextureType"] = "Decal",	
							["Texture"] = "rbxassetid://".. asset	
						}	
					}	
				}	
				_(args)	
			end	
			
			function spam(id)	
				for i,v in game.workspace:GetDescendants() do	
					if v:IsA("BasePart") then	
						spawn(function()	
							SetLocked(v,false)	
							SpawnDecal(v,Enum.NormalId.Front)	
							AddDecal(v,id,Enum.NormalId.Front)	
			
							SpawnDecal(v,Enum.NormalId.Back)	
							AddDecal(v,id,Enum.NormalId.Back)	
			
							SpawnDecal(v,Enum.NormalId.Right)	
							AddDecal(v,id,Enum.NormalId.Right)	
			
							SpawnDecal(v,Enum.NormalId.Left)	
							AddDecal(v,id,Enum.NormalId.Left)	
			
							SpawnDecal(v,Enum.NormalId.Bottom)	
							AddDecal(v,id,Enum.NormalId.Bottom)	
			
							SpawnDecal(v,Enum.NormalId.Top)	
							AddDecal(v,id,Enum.NormalId.Top)	
						end)	
					end	
				end 	
			end	
			spam("76024088523758")	
				
	end)	
end;
task.spawn(C_6);

local function C_8()
	local script = LMG2L["LocalScript_8"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local player = game.Players.LocalPlayer	
	local char = player.Character	
	local tool	
	
	for i,v in player:GetDescendants() do	
		if v.Name == "SyncAPI" then	
			tool = v.Parent	
		end	
	end	
	
	for i,v in game.ReplicatedStorage:GetDescendants() do	
		if v.Name == "SyncAPI" then	
			tool = v.Parent	
		end	
	end	
	
	remote = tool.SyncAPI.ServerEndpoint	
	function _(args)	
		remote:InvokeServer(unpack(args))	
	end	
	
	function SetCollision(part,boolean)	
		local args = {	
			[1] = "SyncCollision",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["CanCollide"] = boolean	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SetAnchor(boolean,part)	
		local args = {	
			[1] = "SyncAnchor",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Anchored"] = boolean	
				}	
			}	
		}	
		_(args)	
	end	
	
	function CreatePart(cf,parent)	
		local args = {	
			[1] = "CreatePart",	
			[2] = "Normal",	
			[3] = cf,	
			[4] = parent	
		}	
		_(args)	
	end	
	
	function DestroyPart(part)	
		local args = {	
			[1] = "Remove",	
			[2] = {	
				[1] = part	
			}	
		}	
		_(args)	
	end	
	
	function MovePart(part,cf)	
		local args = {	
			[1] = "SyncMove",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["CFrame"] = cf	
				}	
			}	
		}	
		_(args)	
	end	
	
	function Resize(part,size,cf)	
		local args = {	
			[1] = "SyncResize",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["CFrame"] = cf,	
					["Size"] = size	
				}	
			}	
		}	
		_(args)	
	end	
	
	function AddMesh(part)	
		local args = {	
			[1] = "CreateMeshes",	
			[2] = {	
				[1] = {	
					["Part"] = part	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SetMesh(part,meshid)	
		local args = {	
			[1] = "SyncMesh",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["MeshId"] = "rbxassetid://"..meshid	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SetTexture(part, texid)	
		local args = {	
			[1] = "SyncMesh",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["TextureId"] = "rbxassetid://"..texid	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SetName(part, stringg)	
		local args = {	
			[1] = "SetName",	
			[2] = {	
				[1] = part	
			},	
			[3] = stringg	
		}	
		_(args)	
	end	
	
	function MeshResize(part,size)	
		local args = {	
			[1] = "SyncMesh",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Scale"] = size	
				}	
			}	
		}	
		_(args)	
	end	
	
	function Weld(part1, part2,lead)	
		local args = {	
			[1] = "CreateWelds",	
			[2] = {	
				[1] = part1,	
				[2] = part2	
			},	
			[3] = lead	
		}	
		_(args)	
	end	
	
	function SetLocked(part,boolean)	
		local args = {	
			[1] = "SetLocked",	
			[2] = {	
				[1] = part	
			},	
			[3] = boolean	
		}	
		_(args)	
	end	
	
	function SetTrans(part,int)	
		local args = {	
			[1] = "SyncMaterial",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Transparency"] = int	
				}	
			}	
		}	
		_(args)	
	end	
	
	function CreateSpotlight(part)	
		local args = {	
			[1] = "CreateLights",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["LightType"] = "SpotLight"	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SyncLighting(part,brightness)	
		local args = {	
			[1] = "SyncLighting",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["LightType"] = "SpotLight",	
					["Brightness"] = brightness	
				}	
			}	
		}	
		_(args)	
	end	
	
	function Color(part,color)	
		local args = {	
			[1] = "SyncColor",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Color"] = color,	
					["UnionColoring"] = false	
				}	
			}	
		}	
		_(args)	
	end	
	
	function SpawnDecal(part,side)	
		local args = {	
			[1] = "CreateTextures",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Face"] = side,	
					["TextureType"] = "Decal"	
				}	
			}	
		}	
		_(args)	
	end	
	
	function AddDecal(part,asset,side)	
		local args = {	
			[1] = "SyncTexture",	
			[2] = {	
				[1] = {	
					["Part"] = part,	
					["Face"] = side,	
					["TextureType"] = "Decal",	
					["Texture"] = "rbxassetid://".. asset	
				}	
			}	
		}	
		_(args)	
	end	
	
	function Sky(id)	
		local root = char:WaitForChild("HumanoidRootPart")	
		local pos = root.CFrame + Vector3.new(0, 6, 0)	
		CreatePart(pos, workspace)	
		task.wait(0.2)	
		local skyPart	
		for _, v in workspace:GetChildren() do	
			if v:IsA("BasePart") and (v.Position - pos.Position).magnitude < 1 then	
				skyPart = v	
				break	
			end	
		end	
		if skyPart then	
			SetName(skyPart, "Sky")	
			AddMesh(skyPart)	
			SetMesh(skyPart, "111891702759441")	
			SetTexture(skyPart, id)	
			MeshResize(skyPart, Vector3.new(1000, 1000, 1000))	
			SetLocked(skyPart, true)	
			SetAnchor(true, skyPart)	
		end	
	end	
	
	Sky("76024088523758")	
	
	--Please leave this credit	
	--Script made by Yaazkidd (I copy inspiration from blue2spooky wooo)	
	end)	
end;
task.spawn(C_8);

local function C_a()
	local script = LMG2L["LocalScript_a"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
		local player = game.Players.LocalPlayer	
		local char = player.Character	
		local tool	
		for i,v in player:GetDescendants() do	
			if v.Name == "SyncAPI" then	
				tool = v.Parent	
			end	
		end	
		for i,v in game.ReplicatedStorage:GetDescendants() do	
			if v.Name == "SyncAPI" then	
				tool = v.Parent	
			end	
		end	
		remote = tool.SyncAPI.ServerEndpoint	
		function _(args)	
			remote:InvokeServer(unpack(args))	
		end	
		function SetCollision(part,boolean)	
			local args = {	
				[1] = "SyncCollision",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["CanCollide"] = boolean	
					}	
				}	
			}	
			_(args)	
		end	
		function SetAnchor(boolean,part)	
			local args = {	
				[1] = "SyncAnchor",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Anchored"] = boolean	
					}	
				}	
			}	
			_(args)	
		end	
		function CreatePart(cf,parent)	
			local args = {	
				[1] = "CreatePart",	
				[2] = "Normal",	
				[3] = cf,	
				[4] = parent	
			}	
			_(args)	
		end	
		function DestroyPart(part)	
			local args = {	
				[1] = "Remove",	
				[2] = {	
					[1] = part	
				}	
			}	
			_(args)	
		end	
		function MovePart(part,cf)	
			local args = {	
				[1] = "SyncMove",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["CFrame"] = cf	
					}	
				}	
			}	
			_(args)	
		end	
		function Resize(part,size,cf)	
			local args = {	
				[1] = "SyncResize",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["CFrame"] = cf,	
						["Size"] = size	
					}	
				}	
			}	
			_(args)	
		end	
		function AddMesh(part)	
			local args = {	
				[1] = "CreateMeshes",	
				[2] = {	
					[1] = {	
						["Part"] = part	
					}	
				}	
			}	
			_(args)	
		end	
	
		function SetMesh(part,meshid)	
			local args = {	
				[1] = "SyncMesh",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["MeshId"] = "rbxassetid://"..meshid	
					}	
				}	
			}	
			_(args)	
		end	
		function SetTexture(part, texid)	
			local args = {	
				[1] = "SyncMesh",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["TextureId"] = "rbxassetid://"..texid	
					}	
				}	
			}	
			_(args)	
		end	
		function SetName(part, stringg)	
			local args = {	
				[1] = "SetName",	
				[2] = {	
					[1] = part	
				},	
				[3] = stringg	
			}	
	
			_(args)	
		end	
		function MeshResize(part,size)	
			local args = {	
				[1] = "SyncMesh",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Scale"] = size	
					}	
				}	
			}	
			_(args)	
		end	
		function Weld(part1, part2,lead)	
			local args = {	
				[1] = "CreateWelds",	
				[2] = {	
					[1] = part1,	
					[2] = part2	
				},	
				[3] = lead	
			}	
			_(args)	
	
		end	
		function SetLocked(part,boolean)	
			local args = {	
				[1] = "SetLocked",	
				[2] = {	
					[1] = part	
				},	
				[3] = boolean	
			}	
			_(args)	
		end	
		function SetTrans(part,int)	
			local args = {	
				[1] = "SyncMaterial",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Transparency"] = int	
					}	
				}	
			}	
			_(args)	
		end	
		function CreateSpotlight(part)	
			local args = {	
				[1] = "CreateLights",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["LightType"] = "SpotLight"	
					}	
				}	
			}	
			_(args)	
		end	
		function SyncLighting(part,brightness)	
			local args = {	
				[1] = "SyncLighting",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["LightType"] = "SpotLight",	
						["Brightness"] = brightness	
					}	
				}	
			}	
			_(args)	
		end	
		function Color(part,color)	
			local args = {	
				[1] = "SyncColor",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Color"] = color --[[Color3]],	
						["UnionColoring"] = false	
					}	
				}	
			}	
			_(args)	
		end	
		function SpawnDecal(part,side)	
			local args = {	
				[1] = "CreateTextures",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Face"] = side,	
						["TextureType"] = "Decal"	
					}	
				}	
			}	
	
			_(args)	
		end	
		function AddDecal(part,asset,side)	
			local args = {	
				[1] = "SyncTexture",	
				[2] = {	
					[1] = {	
						["Part"] = part,	
						["Face"] = side,	
						["TextureType"] = "Decal",	
						["Texture"] = "rbxassetid://".. asset	
					}	
				}	
			}	
			_(args)	
		end	
	
		function Sky(id)	
			e = char.HumanoidRootPart.CFrame.x	
			f = char.HumanoidRootPart.CFrame.y	
			g = char.HumanoidRootPart.CFrame.z	
			CreatePart(CFrame.new(math.floor(e),math.floor(f),math.floor(g)) + Vector3.new(0,6,0),workspace)	
			for i,v in game.Workspace:GetDescendants() do	
				if v:IsA("BasePart") and v.CFrame.x == math.floor(e) and v.CFrame.z == math.floor(g) then	
					--spawn(function()	
					SetName(v,"Sky")	
					AddMesh(v)	
					--end)	
					--spawn(function()	
					SetMesh(v,"111891702759441")	
					SetTexture(v,id)	
					--end)	
					MeshResize(v,Vector3.new(4000, 4000, 4000))	
					SetLocked(v,true)	
				end	
			end	
		end	
		Sky("76024088523758")	
	
	local skyPart	
	for _, v in workspace:GetDescendants() do	
		if v:IsA("BasePart") and v.Name == "Sky" then	
			skyPart = v	
			break	
		end	
	end	
	
	if skyPart then	
		task.spawn(function()	
			while true do	
				-- Rotate 1 degree per frame around Y-axis	
				local currentCFrame = skyPart.CFrame	
				local newCFrame = currentCFrame * CFrame.Angles(	
	                                            math.rad(-1), -- rotate 0.5 degrees around X-axis	
	                                            math.rad(0.5),   -- rotate 1 degree around Y-axis	
	                                            math.rad(1)  -- rotate 0.3 degrees around Z-axis	
	                                    )	
	                                   MovePart(skyPart, newCFrame)	
	                                   task.wait(0.01)				
			end	
		end)	
	end	
	end)	
end;
task.spawn(C_a);

local function C_c()
	local script = LMG2L["LocalScript_c"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";btools")	
	end)	
end;
task.spawn(C_c);

local function C_e()
	local script = LMG2L["LocalScript_e"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";titleg all download..")	
	end)	
end;
task.spawn(C_e);

local function C_10()
	local script = LMG2L["LocalScript_10"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";char all Virus_computer666")	
	end)	
end;
task.spawn(C_10);

local function C_12()
	local script = LMG2L["LocalScript_12"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";disco")	
	end)	
end;
task.spawn(C_12);

local function C_14()
	local script = LMG2L["LocalScript_14"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";music 102295928741521 ;pitch 0.13 ;volume inf")	
	end)	
end;
task.spawn(C_14);

local function C_16()
	local script = LMG2L["LocalScript_16"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";kill other")	
	end)	
end;
task.spawn(C_16);

local function C_18()
	local script = LMG2L["LocalScript_18"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";titler other download...")	
	end)	
end;
task.spawn(C_18);

local function C_1a()
	local script = LMG2L["LocalScript_1a"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";alert all download.. unknow.exe")	
	end)	
end;
task.spawn(C_1a);

local function C_1c()
	local script = LMG2L["LocalScript_1c"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";serverhint unknow.exe is hacking game")	
	end)	
end;
task.spawn(C_1c);

local function C_1e()
	local script = LMG2L["LocalScript_1e"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";servermessage 824982946283")	
	end)	
end;
task.spawn(C_1e);

local function C_20()
	local script = LMG2L["LocalScript_20"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";tp all")	
	end)	
end;
task.spawn(C_20);

local function C_22()
	local script = LMG2L["LocalScript_22"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";cmdbar2")	
	end)	
end;
task.spawn(C_22);

local function C_24()
	local script = LMG2L["LocalScript_24"];
	--button script	
	local button = script.Parent	
	button.MouseButton1Click:Connect(function()	
	local ReplicatedStorage = game:GetService("ReplicatedStorage")		local RequestCommand = ReplicatedStorage:WaitForChild("HDAdminHDClient").Signals.RequestCommandSilent	
	
	RequestCommand:InvokeServer(";r6")	
	end)	
end;
task.spawn(C_24);

return LMG2L["ScreenGui_1"], require;
