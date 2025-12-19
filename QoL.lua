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

local liveryTakerLoaded = false

local saveConfig = QoLTab:Button({
	Title = "Loadup livery taker",
	Desc = "Loads the newest version of livery (surely not an ad)",
	Locked = false,
	Callback = function()
		if not liveryTakerLoaded then
			liveryTakerLoaded = true
			loadstring(
				game:HttpGet(
					"https://gist.githubusercontent.com/adamMasMusic/ccc3a8d40e2d7747fcb197827775f86d/raw/ee98f8107a1c000f0527c03ab3ef74d57cf3cb35/livery_taker_v4.lua"
				)
			)()
		end
	end,
})

QoLConfig:Load()

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
	end)
end)
