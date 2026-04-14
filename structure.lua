repeat
	task.wait()
until _G.WindUI and _G.Functions

local Tabs = _G.Tabs

local structure = {
	main = {
		Tab = Tabs.Main,
		Respawn = nil,
	},
	localPlayer = {
		Tab = Tabs.LocalPlayer,
		InfiniteJump = nil,
		WalkSpeed = nil,
		WalkSpeedValue = nil,
		Noclip = nil,
		AntiVoid = nil,
	},
	trolling = {
		Tab = Tabs.Trolling,
		MakeClosestVehicleDirt = nil,
		PopAllTires = nil,
		TripAll = nil,
		WalkFling = nil,
		CarFling = nil,
		FakeModCalls = nil,
		PunchAura = nil,
		Invisibility = nil,
		ShockEarrape = nil,
	},
	vehicleMods = {
		NoCollision = nil,
	},
}

for _, item in Tabs.Main.Elements do
	if item.Title == "Respawn" then
		structure.main.Respawn = item
	end
end

for _, item in Tabs.VehicleMods.Elements do
	if item.Title == "Vehicle Noclip" then
		structure.vehicleMods.NoCollision = item
	end
end

for _, item in Tabs.LocalPlayer.Elements do
	if item.Title == "Infinite Jump" then
		structure.localPlayer.InfiniteJump = item
	elseif item.Title == "Walk Speed" then
		structure.localPlayer.WalkSpeed = item
	elseif item.Title == "WalkSpeed" then
		structure.localPlayer.WalkSpeedValue = item
	elseif item.Title == "Noclip" then
		structure.localPlayer.Noclip = item
	elseif item.Title == "Anti Void" then
		structure.localPlayer.AntiVoid = item
	end
end

for _, item in Tabs.Trolling.Elements do
	if item.Title == "Make Closest Vehicle Dirt   👑" then
		structure.trolling.MakeClosestVehicleDirt = item
	elseif item.Title == "Pop All Tires   👑" then
		structure.trolling.PopAllTires = item
	elseif item.Title == "Trip All   👑" then
		structure.trolling.TripAll = item
	elseif item.Title == "Walk Fling" then
		structure.trolling.WalkFling = item
	elseif item.Title == "Car Fling" then
		structure.trolling.CarFling = item
	elseif item.Title == "Fake Mod Calls   👑" then
		structure.trolling.FakeModCalls = item
	elseif item.Title == "Punch Aura" then
		structure.trolling.PunchAura = item
	elseif item.Title == "Invisibility" then
		structure.trolling.Invisibility = item
	elseif item.Title == "Shock Earrape   👑" then
		structure.trolling.ShockEarrape = item
	end
end

_G.ERXStructure = structure
