if _G.ERXQoL then
	warn("QoL already loaded or is loading!")
	return
end

_G.ERXQoL = true

loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/structure.lua"))()

repeat
	task.wait()
until _G.ERXStructure

local userInputService = game:GetService("UserInputService")

local WindUI = _G.WindUI
local Window = _G.Window
local ConfigManager = Window.ConfigManager
local Tabs = _G.Tabs
local structure = _G.ERXStructure
local QoLConfig = ConfigManager:CreateConfig("ERXQoL")

local QoLTab = Window:Tab({
	Title = "QoL",
	Icon = "settings",
	Locked = false,
})

local Section = QoLTab:Section({
	Title = "Flinging",
})

local originalWalkFling = nil
local originalCarFling = nil

local autoNoclipToggle = QoLTab:Toggle({
	Title = "Auto noclip",
	Desc = "Auto toggles noclip for walk fling and car fling",
	Value = false,
	Callback = function(state)
		if state then
			originalWalkFling = hookfunction(structure.trolling.WalkFling.Callback, function(toggleState)
				structure.localPlayer.Noclip:Set(toggleState)
				return originalWalkFling(toggleState)
			end)
			originalCarFling = hookfunction(structure.trolling.CarFling.Callback, function(toggleState)
				structure.vehicleMods.NoCollision:Set(toggleState)
				return originalCarFling(toggleState)
			end)
		else
			if originalWalkFling then
				hookfunction(structure.trolling.WalkFling.Callback, originalWalkFling)
			end
			if originalCarFling then
				hookfunction(structure.trolling.CarFling.Callback, originalCarFling)
			end
		end
	end,
})
QoLConfig:Register("autoNoclipToggle", autoNoclipToggle)

local flingKeybindEnabled = true

local flingKeybindToggle = QoLTab:Toggle({
	Title = "Enable Fling Keybind",
	Desc = "Choose if you want the fling keybind enabled",
	Value = true,
	Callback = function(state)
		flingKeybindEnabled = state
	end,
})
QoLConfig:Register("flingKeybindToggle", flingKeybindToggle)

local currentFlingKeybind = Enum.KeyCode.V

local flingKeybind = QoLTab:Keybind({
	Title = "Fling Keybind",
	Desc = "Toggle fling with a single press of a button (if you are in car it does car fling otherwise walk fling)",
	Value = "V",
	Callback = function(v)
		currentFlingKeybind = Enum.KeyCode[v]
	end,
})
QoLConfig:Register("flingKeybind", flingKeybind)

local Section = QoLTab:Section({
	Title = "Noclip",
})

local noclipKeybindEnabled = true

local noclipKeybindToggle = QoLTab:Toggle({
	Title = "Enable Noclip Keybind",
	Desc = "Choose if you want the noclip keybind enabled",
	Value = true,
	Callback = function(state)
		noclipKeybindEnabled = state
	end,
})
QoLConfig:Register("noclipKeybindToggle", noclipKeybindToggle)

local currentNoclipKeybind = Enum.KeyCode.C

local noclipKeybind = QoLTab:Keybind({
	Title = "Noclip Keybind",
	Desc = "Toggle noclip with a single press of a button (if you are in car it does car noclip otherwise normal noclip)",
	Value = "C",
	Callback = function(v)
		currentNoclipKeybind = Enum.KeyCode[v]
	end,
})
QoLConfig:Register("flingKeybind", flingKeybind)

local Section = QoLTab:Section({
	Title = "Respawn",
})

local respawnKeybindEnabled = true

local respawnKeybindToggle = QoLTab:Toggle({
	Title = "Enable Respawn Keybind",
	Desc = "Choose if you want the respawn keybind enabled",
	Value = true,
	Callback = function(state)
		respawnKeybindEnabled = state
	end,
})
QoLConfig:Register("respawnKeybindToggle", respawnKeybindToggle)

local currentRespawnKeybind = Enum.KeyCode.Z

local respawnKeybind = QoLTab:Keybind({
	Title = "Respawn Keybind",
	Desc = "Respawn yourself with a single press of a key.",
	Value = "Z",
	Callback = function(v)
		currentRespawnKeybind = Enum.KeyCode[v]
	end,
})
QoLConfig:Register("respawnKeybind", respawnKeybind)

local Section = QoLTab:Section({
	Title = "Invisibility",
})

local invisibilityKeybindEnabled = true

local invisibilityKeybindToggle = QoLTab:Toggle({
	Title = "Enable Invisibility Keybind",
	Desc = "Choose if you want the invisibility keybind enabled",
	Value = true,
	Callback = function(state)
		invisibilityKeybindEnabled = state
	end,
})
QoLConfig:Register("invisibilityKeybindToggle", invisibilityKeybindToggle)

local currentInvisibilityKeybind = Enum.KeyCode.X

local invisibilityKeybind = QoLTab:Keybind({
	Title = "Invisibility Keybind",
	Desc = "Toggle your invisibility with a single press of a key.",
	Value = "X",
	Callback = function(v)
		currentInvisibilityKeybind = Enum.KeyCode[v]
	end,
})
QoLConfig:Register("invisibilityKeybind", invisibilityKeybind)

local Section = QoLTab:Section({
	Title = "Pop all tires",
})

local popAllKeybindEnabled = true

local popAllKeybindToggle = QoLTab:Toggle({
	Title = "Enable Pop All Keybind",
	Desc = "Choose if you want the pop all keybind enabled",
	Value = true,
	Callback = function(state)
		popAllKeybindEnabled = state
	end,
})
QoLConfig:Register("popAllKeybindToggle", popAllKeybindToggle)

local currentPopAllKeybind = Enum.KeyCode.K

local popAllKeybind = QoLTab:Keybind({
	Title = "Pop All Tires Keybind",
	Desc = "Pop all tires with a single press of a key.",
	Value = "K",
	Callback = function(v)
		currentPopAllKeybind = Enum.KeyCode[v]
	end,
})
QoLConfig:Register("popAllKeybind", popAllKeybind)

local Section = QoLTab:Section({
	Title = "Random",
})

local saveConfig = QoLTab:Button({
	Title = "Save Config",
	Desc = "Saves your config so it can be loaded next time",
	Locked = false,
	Callback = function()
		QoLConfig:Save()
	end,
})

local customFeaturesAdd = QoLTab:Button({
	Title = "Add to custom features",
	Desc = "Adds this script to custom features so it loads every time with ERX",
	Locked = false,
	Callback = function()
		local customFeatures = "WindUI/CustomFeatures/CustomFeatures.lua"
		local s = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/QoL.lua"))() --QoL for ERX
]]
		appendfile(customFeatures, s)
	end,
})

local liveryTakerLoaded = false

local assetTakerLoader = QoLTab:Button({
	Title = "Loadup asset taker",
	Desc = "Loads the newest version of asset taker (surely not an ad)",
	Locked = false,
	Callback = function()
		if not liveryTakerLoaded then
			liveryTakerLoaded = true
			loadstring(
				game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/asset_taker.lua")
			)()
		end
	end,
})

QoLConfig:Load()

WindUI:Notify({
	Title = "QoL loaded",
	Content = "Enjoy your fancy keybinds and settings!",
	Duration = 3,
})

--keybinds ig
task.spawn(function()
	userInputService.InputBegan:Connect(function(input, proc)
		if proc or not _G.WindUI then
			return
		end

		if flingKeybindEnabled and input.KeyCode == currentFlingKeybind then
			if
				game.Players.LocalPlayer.Character
				and game.Players.LocalPlayer.Character.Humanoid
				and game.Players.LocalPlayer.Character.Humanoid.SeatPart
				and game.Players.LocalPlayer.Character.Humanoid.SeatPart:IsDescendantOf(workspace.Vehicles)
			then
				local o = structure.trolling.CarFling.Value
				structure.trolling.CarFling:Set(not o)
			else
				local o = structure.trolling.WalkFling.Value
				structure.trolling.WalkFling:Set(not o)
			end
		end
		if noclipKeybindEnabled and input.KeyCode == currentNoclipKeybind then
			if
				game.Players.LocalPlayer.Character
				and game.Players.LocalPlayer.Character.Humanoid
				and game.Players.LocalPlayer.Character.Humanoid.SeatPart
				and game.Players.LocalPlayer.Character.Humanoid.SeatPart:IsDescendantOf(workspace.Vehicles)
			then
				local o = structure.vehicleMods.NoCollision.Value
				structure.vehicleMods.NoCollision:Set(not o)
			else
				local o = structure.localPlayer.Noclip.Value
				structure.localPlayer.Noclip:Set(not o)
			end
		end
		if invisibilityKeybindEnabled and input.KeyCode == currentInvisibilityKeybind then
			local o = structure.trolling.Invisibility.Value
			structure.trolling.Invisibility:Set(not o)
		end
		if respawnKeybindEnabled and input.KeyCode == currentRespawnKeybind then
			structure.main.Respawn.Callback()
		end
		if popAllKeybindEnabled and input.KeyCode == currentPopAllKeybind then
			structure.trolling.PopAllTires.Callback()
		end
	end)
end)
