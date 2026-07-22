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
    TeamChange = _G.Functions.safeGetRemote("TeamChange"),
	ChangeLightbulb = _G.Functions.safeGetRemote("ChangeLightbulb"),
	FirewallHack = _G.Functions.safeGetRemote("FirewallHack"),
	ConnectWires = _G.Functions.safeGetRemote("ConnectWires"),
	Crowbar = _G.Functions.safeGetRemote("Crowbar"),
	BuyGas = _G.Functions.safeGetRemote("BuyGas"),
	BuyGun = _G.Functions.safeGetRemote("BuyGun"),
	EquipGun = _G.Functions.safeGetRemote("EquipGun"),
	BuyGear = _G.Functions.safeGetRemote("BuyGear"),
	BuyAmmo = _G.Functions.safeGetRemote("BuyAmmo"),
	VehicleSit = _G.Functions.safeGetRemote("VehicleSit"),
	DeliverPackage = _G.Functions.safeGetRemote("DeliverPackage"), --maybe
	StealItem = _G.Functions.safeGetRemote("StealItem"),
	FoodDrive = _G.Functions.safeGetRemote("FoodDrive"), --maybe
	["Weapons.ReplicateWaist"] = _G.Functions.safeGetRemote("Weapons.ReplicateWaist"),
	["Weapons.FlashShield"] = _G.Functions.safeGetRemote("Weapons.FlashShield"),
	["Weapons.ResetTaser"] = _G.Functions.safeGetRemote("Weapons.ResetTaser"),
	["Weapons.ValidateDarts"] = _G.Functions.safeGetRemote("Weapons.ValidateDarts"),
	["Weapons.ReplicateProjectile"] = _G.Functions.safeGetRemote("Weapons.ReplicateProjectile"),
}
