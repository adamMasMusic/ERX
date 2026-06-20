loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/extraFunctions.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/structure.lua"))()

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInputService = game:GetService("UserInputService")

repeat task.wait() until _G.ExtraFuctions and _G.WindUI and _G.ERXStructure

_G.HelicopterFly = true

local WindUI = _G.WindUI
local Window = _G.Window
local ConfigManager = Window.ConfigManager
local Structure = _G.ERXStructure

local CarModsConfig = ConfigManager:CreateConfig("ERXCarMods")

local carModsTab = Window:Tab({
    Title = "Car mods",
    Icon = "car",
    Locked = false,
})

local carFlySection = carModsTab:Section({
    Title = "Car fly",
})

local speed = 200
local multiplier = 2
local lp = players.LocalPlayer
local keys = {
    W = false,
    A = false,
    S = false,
    D = false,
    Q = false,
    E = false,
    LeftShift = false
}
local moves = {
    W = Vector3.new(0,0,-1),
    A = Vector3.new(-1,0,0),
    S = Vector3.new(0,0,1),
    D = Vector3.new(1,0,0),
    Q = Vector3.new(0,-1,0),
    E = Vector3.new(0,1,0)
}

local angle = 0
local angleSpeed = 360
local savedSprings = {}

local function disableSprings(car)
    savedSprings = {}
    for _, wheel in car.Wheels:GetChildren() do
        for _, sp in wheel:GetDescendants() do
            if sp:IsA("SpringConstraint") then
                savedSprings[sp] = sp.Enabled
                sp.Enabled = false
            end
        end
    end
end

local function restoreSprings()
    for sp, was in pairs(savedSprings) do
        pcall(function() sp.Enabled = was end)
    end
    savedSprings = {}
end

local function orbitWheels(dt)
    local car = _G.Functions.getPlayerCar()
    if not car then return end
    if not _G.Functions.isPlayerInOwnCar() then return end

    local pp = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
    if not pp then return end

    local r = _G.helicopterDistance or 10
    local amount = #car.Wheels:GetChildren()
    for i, wheel in car.Wheels:GetChildren() do
        local a = math.rad(angle + (360 * i / amount))
        local lx = math.cos(a) * r
        local lz = math.sin(a) * r
        pcall(function()
            wheel.CFrame = pp.CFrame * CFrame.new(lx, _G.helicopterHeight or 10, lz)
        end)
    end
    angle += angleSpeed * dt
end

local controlledCFrame = nil

local function controlledFly(dt: number)
    local car = _G.Functions.getPlayerCar()
    if not car then return end
    local char = _G.Functions.getChar()
    local isInOwnCar = _G.Functions.isPlayerInOwnCar()
    if char.Humanoid.Sit and not isInOwnCar then return end
    if not isInOwnCar then
        controlledCFrame = nil
        return
    end
    workspace.CurrentCamera.CameraSubject = lp.Character
    _G.Functions.togglePlayerCar(false)

    if not controlledCFrame then
        controlledCFrame = car:GetPivot()
    end

    local pos = controlledCFrame.Position
    local newPos
    local lean = CFrame.identity
    local moveFrame

    if _G.HelicopterFly then
        local _, camY = workspace.CurrentCamera.CFrame:ToOrientation()
        newPos = CFrame.new(pos) * CFrame.Angles(0, camY, 0)
        moveFrame = workspace.CurrentCamera.CFrame.Rotation
        if keys.W then lean *= CFrame.Angles(math.rad(-15), 0, 0) end
        if keys.S then lean *= CFrame.Angles(math.rad(15), 0, 0) end
        if keys.A then lean *= CFrame.Angles(0, 0, math.rad(15)) end
        if keys.D then lean *= CFrame.Angles(0, 0, math.rad(-15)) end
    else
        newPos = CFrame.new(pos) * workspace.CurrentCamera.CFrame.Rotation
        moveFrame = newPos
    end

    local planarMove = Vector3.zero
    local vertMove = 0
    for key, value in keys do
        if value and moves[key] then
            if key == "Q" or key == "E" then
                vertMove += moves[key].Y
            else
                planarMove += moves[key]
            end
        end
    end

    local currentSpeed = keys.LeftShift and (speed * multiplier) or speed

    local world = Vector3.zero
    if planarMove.Magnitude > 0 then
        world += moveFrame:VectorToWorldSpace(planarMove.Unit)
    end
    world += Vector3.new(0, vertMove, 0)
    if world.Magnitude > 0 then
        newPos = newPos + world.Unit * currentSpeed * dt
    end

    controlledCFrame = newPos

    local primary = car.PrimaryPart
    primary.AssemblyLinearVelocity = Vector3.zero
    primary.AssemblyAngularVelocity = Vector3.zero

    if _G.HelicopterFly then
        car:PivotTo(newPos * lean)
        orbitWheels(dt)
    else
        car:PivotTo(newPos)
    end
end

local bounceTime = 0

local function carBounce(dt)
    local car = _G.Functions.getPlayerCar()
    if not car then return end
    if not _G.Functions.isPlayerInOwnCar() then return end

    bounceTime += dt * _G.carBounceSpeed
    local t = bounceTime % 1
    local offset = (t < 0.5 and t * 2 or (1 - t) * 2) * _G.carBounceHeight

    for _, wheel in car.Wheels:GetChildren() do
        _G.Functions.applyAxleOffset(wheel, { Y = -offset - _G.carBounceStart })
    end
end

local carFlyToggle = carModsTab:Toggle({
    Title = "Enable Car Fly",
    Desc = "Weeeeeeeeeeeeeeee",
    Default = false,
    Callback = function(state)
        if not state then
            restoreSprings()
            if _G.Functions.isDriving() then
                _G.Functions.togglePlayerCar(true)
            end
        else
            disableSprings(_G.Functions.getPlayerCar())
        end
        controlledCFrame = nil
        _G.carFlyEnabled = state
    end,
})

local carFlySpeed = carModsTab:Slider({
    Title = "Car fly speed",
    Desc = "Sets how fast you fly duh",
    Step = 20,
    Value = {
        Min = 50,
        Max = 1000,
        Default = 200,
    },
    Callback = function(value)
        speed = value
    end,
})
CarModsConfig:Register("carFlySpeed", carFlySpeed)

local carFlyBoost = carModsTab:Slider({
    Title = "Car fly boost speed",
    Desc = "Sets the multiplier of how fast you go when you press Left Shift",
    Step = 0.2,
    Value = {
        Min = 1,
        Max = 10,
        Default = 2,
    },
    Callback = function(value)
        multiplier = value
    end,
})
CarModsConfig:Register("carFlyBoost", carFlyBoost)

local carFlyHelicopterToggle = carModsTab:Toggle({
    Title = "Enable Helicopter mode",
    Desc = "Helicopter helicopter",
    Default = false,
    Callback = function(state)
        _G.HelicopterFly = state
    end,
})

local carFlyHelicopterDistance = carModsTab:Slider({
    Title = "Helicopter distance",
    Desc = "idfk how to explain this",
    Step = 1,
    Value = {
        Min = 1,
        Max = 50,
        Default = 10,
    },
    Callback = function(value)
        _G.helicopterDistance = value
        --helicopterHeight
    end,
})
CarModsConfig:Register("carFlyHelicopterDistance", carFlyHelicopterDistance)

local carFlyHelicopterHeight = carModsTab:Slider({
    Title = "Helicopter height",
    Desc = "idfk how to explain this",
    Step = 1,
    Value = {
        Min = -20,
        Max = 20,
        Default = 10,
    },
    Callback = function(value)
        _G.helicopterHeight = value
    end,
})
CarModsConfig:Register("carFlyHelicopterHeight", carFlyHelicopterHeight)

local carFlyKeybindEnabled = false
local carFlyKeybindToggle = carModsTab:Toggle({
    Title = "Enable Car Fly Keybind",
    Desc = "Enable the keybind for car fly",
    Default = false,
    Callback = function(state)
        carFlyKeybindEnabled = state
    end
})
CarModsConfig:Register("carFlyKeybindToggle", carFlyKeybindToggle)

local currentFlyKeybind = Enum.KeyCode.F
local carFlyKeybind = carModsTab:Keybind({
    Title = "Car Fly Keybind",
	Desc = "Toggle weeeeeeeeeeeeeeeeeeeeeee",
	Value = "F",
	Callback = function(v)
		currentFlyKeybind = Enum.KeyCode[v]
	end
})
CarModsConfig:Register("carFlyKeybind", carFlyKeybind)

local carFlySection = carModsTab:Section({
    Title = "Bounce",
})

_G.carBounceEnabled = false
local carBounceToggle = carModsTab:Toggle({
    Title = "Enable Car Bounce",
    Desc = "Bouncy bounce",
    Default = false,
    Callback = function(state)
        _G.carBounceEnabled = state
    end
})

_G.carBounceHeight = 3
local carBounceHeightSlider = carModsTab:Slider({
    Title = "Car bounce height",
    Desc = "Tall car",
    Step = 0.2,
    Value = {
        Min = 0,
        Max = 20,
        Default = 3,
    },
    Callback = function(value)
        _G.carBounceHeight = value
    end,
})
CarModsConfig:Register("carBounceHeightSlider", carBounceHeightSlider)

_G.carBounceSpeed = 0.5
local carBounceSpeedSlider = carModsTab:Slider({
    Title = "Car bounce speed",
    Desc = "Bounce speed",
    Step = 0.1,
    Value = {
        Min = 0,
        Max = 20,
        Default = 0.5,
    },
    Callback = function(value)
        _G.carBounceSpeed = value
    end,
})
CarModsConfig:Register("carBounceSpeedSlider", carBounceSpeedSlider)

_G.carBounceStart = 0
local carBounceStartSlider = carModsTab:Slider({
    Title = "Car bounce start height",
    Desc = "Basically ride height but for bounce",
    Step = 0.1,
    Value = {
        Min = -20,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        _G.carBounceStart = value
    end,
})
CarModsConfig:Register("carBounceStartSlider", carBounceStartSlider)

local carFlySection = carModsTab:Section({
    Title = "Wheel mods",
})

local camber = carModsTab:Slider({
    Title = "Apply camber",
    Desc = "Modifies the camber of the wheels",
    Step = 1,
    Value = {
        Min = -90,
        Max = 90,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            _G.Functions.applyCamber(wheel, value)
        end
    end,
})

local rideHeight = carModsTab:Slider({
    Title = "Ride height",
    Desc = "Modifies the wheels for a custom ride height offset",
    Step = 0.1,
    Value = {
        Min = -2,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            _G.Functions.applyAxleOffset(wheel, {Y = -value})
        end
    end,
})

local wheelWidth = carModsTab:Slider({
    Title = "Wheel width",
    Desc = "Modifies the wheels for a custom wheel width",
    Step = 0.1,
    Value = {
        Min = -20,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            _G.Functions.applyAxleOffset(wheel, {X = value})
        end
    end,
})

local rideHeight = carModsTab:Slider({
    Title = "Ride height front left",
    Step = 0.1,
    Value = {
        Min = -2,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            if wheel.Name == "FL" then
                _G.Functions.applyAxleOffset(wheel, {Y = -value})
            end
        end
    end,
})

local rideHeight = carModsTab:Slider({
    Title = "Ride height front right",
    Step = 0.1,
    Value = {
        Min = -2,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            if wheel.Name == "FR" then
                _G.Functions.applyAxleOffset(wheel, {Y = -value})
            end
        end
    end,
})

local rideHeight = carModsTab:Slider({
    Title = "Ride height rear left",
    Step = 0.1,
    Value = {
        Min = -2,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            if wheel.Name == "RL" then
                _G.Functions.applyAxleOffset(wheel, {Y = -value})
            end
        end
    end,
})

local rideHeight = carModsTab:Slider({
    Title = "Ride height rear right",
    Step = 0.1,
    Value = {
        Min = -2,
        Max = 20,
        Default = 0,
    },
    Callback = function(value)
        local car = _G.Functions.getPlayerCar()
        if not car then return end
        for _, wheel in car.Wheels:GetChildren() do
            if wheel.Name == "RR" then
                _G.Functions.applyAxleOffset(wheel, {Y = -value})
            end
        end
    end,
})

local carFlySection = carModsTab:Section({
    Title = "Other",
})

local saveConfig = carModsTab:Button({
	Title = "Save Config",
	Desc = "Saves your config so it can be loaded next time",
	Locked = false,
	Callback = function()
		CarModsConfig:Save()
	end,
})

CarModsConfig:Load()

userInputService.InputBegan:Connect(function(input: InputObject, gp: boolean)
    if gp then return end
    if carFlyKeybindEnabled and input.KeyCode == currentFlyKeybind then
        carFlyToggle:Set(not _G.carFlyEnabled)
    end
    local key = input.KeyCode.Name
    if keys[key] ~= nil then keys[key] = true end
end)

userInputService.InputEnded:Connect(function(input: InputObject)
    local key = input.KeyCode.Name
    if keys[key] ~= nil then keys[key] = false end
end)

runService.Heartbeat:Connect(function(dt: number)
    if _G.carFlyEnabled then
        controlledFly(dt)
    end
    if _G.carBounceEnabled then
        carBounce(dt)
    end
end)
