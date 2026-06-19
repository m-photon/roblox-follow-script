--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local args = {
	"cmd",
	"-gh 5316479641,5316539421,5268602207,5316549755,132006952641112,102523984905681,77986176057943,89328465080930,111787383238402,126699902233201,138364679836274"
}
game:GetService("ReplicatedStorage"):WaitForChild("01_server"):FireServer(unpack(args))

wait(2)

local args = {
	"cmd",
	"-pd"
}
game:GetService("ReplicatedStorage"):WaitForChild("01_server"):FireServer(unpack(args))

task.wait(2)

game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("Axirian glitcher hats by Tory")

task.wait(1)

game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("btw already -pd")

task.wait(1)

game:GetService("TextChatService").TextChannels.RBXGeneral:SendAsync("(DUDE WHY I CREATE THIS SCRIPT)")
