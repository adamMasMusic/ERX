local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

if _G.safeRemotes then return warn("[QoL] remotes already loaded") end

repeat task.wait() until _G.Functions

local lp = players.LocalPlayer

local secureEnv = getsenv(lp.PlayerScripts:WaitForChild("Client Game Analytics"))
local scriptEnv = getfenv(1)
local network = replicatedStorage.Modules.Network

local network
for _, obj in getgc(true) do
	if type(obj) == "table" and rawget(obj, "Fire") and typeof(rawget(obj, "Fire")) == "function" and rawget(obj, "getRemote")	then
		network = obj
		break
	end
end

if not network then return warn("[QoL] MISSING NETWORK MODULE") end

local oldRemotes = {}

_G.Functions.safeGetRemote = newcclosure(function(remoteName)
    if oldRemotes[remoteName] then return oldRemotes[remoteName] end

    for i = 0, 30 do
        pcall(setfenv, i, secureEnv)
    end

    local realRemote = coroutine.wrap(network.getRemote)(remoteName)

    for i = 0, 30 do
        pcall(setfenv, i, scriptEnv)
    end

    oldRemotes[remoteName] = realRemote
    return realRemote
end)

_G.safeRemotes = {
    TeamChange = _G.Functions.safeGetRemote("TeamChange")
}
