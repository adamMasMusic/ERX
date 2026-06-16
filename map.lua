loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/extraFunctions.lua"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/adamMasMusic/ERX/refs/heads/main/structure.lua"))()

local players = game:GetService("Players")
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")
local lp = players.LocalPlayer

repeat task.wait() until _G.Functions and _G.WindUI and _G.ERXStructure

local Window = _G.Window

local mapTab = Window:Tab({
    Title = "Map View",
    Icon = "map",
    Locked = false,
})

mapTab:Section({ Title = "Map" })

-- State
local active = false
local camX, camZ = 0, 0
local camHeight = 600
local targetHeight = 600
local groundHit = Vector3.zero
local dragging = false
local dragOrigin = Vector2.zero
local sessionConns = {}
local streamClock = 0
local carStashY = -150
local trackTarget = nil
local startPos = nil
local vehicleUI = nil
local mapKeybindEnabled = true
local currentMapKeybind = Enum.KeyCode.J

local function disconnectSession()
    for _, c in sessionConns do
        c:Disconnect()
    end
    sessionConns = {}
end

local function holdCar(car)
    local pp = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
    if not pp then return end
    pp.AssemblyLinearVelocity = Vector3.zero
    pp.AssemblyAngularVelocity = Vector3.zero
    car:PivotTo(CFrame.new(camX, carStashY, camZ))
end

local function teleportCar(car, worldPos)
    task.spawn(function()
        pcall(function() lp:RequestStreamAroundAsync(worldPos, 2) end)
    end)
    car:PivotTo(CFrame.new(worldPos.X, worldPos.Y + 4, worldPos.Z))
    local pp = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
    if pp then
        pp.AssemblyLinearVelocity = Vector3.zero
        pp.AssemblyAngularVelocity = Vector3.zero
    end
end

local function raycastGround(cam)
    local mouse = userInput:GetMouseLocation()
    local ray = cam:ViewportPointToRay(mouse.X, mouse.Y)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {}
    if lp.Character then table.insert(ignore, lp.Character) end
    local car = _G.Functions.getPlayerCar()
    if car then table.insert(ignore, car) end
    params.FilterDescendantsInstances = ignore

    local hit = workspace:Raycast(ray.Origin, ray.Direction * 3000, params)
    return hit and hit.Position or Vector3.new(camX, 0, camZ)
end

local function findVehicleAtCursor()
    local cam = workspace.CurrentCamera
    local mouse = userInput:GetMouseLocation()
    local ray = cam:ViewportPointToRay(mouse.X, mouse.Y)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = {}
    if lp.Character then table.insert(ignore, lp.Character) end
    local car = _G.Functions.getPlayerCar()
    if car then table.insert(ignore, car) end
    params.FilterDescendantsInstances = ignore

    local hit = workspace:Raycast(ray.Origin, ray.Direction * 3000, params)
    if not hit or not hit.Instance then return nil end

    local vehicles = workspace:FindFirstChild("Vehicles")
    if not vehicles then return nil end

    local part = hit.Instance
    while part and part.Parent ~= vehicles do
        part = part.Parent
    end
    return part
end

local function close(teleportPos)
    if not active then return end
    active = false
    disconnectSession()
    dragging = false
    trackTarget = nil

    local cam = workspace.CurrentCamera
    cam.CameraType = Enum.CameraType.Custom
    local char = lp.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then cam.CameraSubject = hum end

    local car = _G.Functions.getPlayerCar()
    if car then
        local pp = car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart")
        if teleportPos then
            teleportCar(car, teleportPos)
            _G.Functions.notif("Map", "Teleported", 2)
        elseif startPos then
            car:PivotTo(CFrame.new(startPos))
            if pp then
                pp.AssemblyLinearVelocity = Vector3.zero
                pp.AssemblyAngularVelocity = Vector3.zero
            end
        end
    end

    if vehicleUI then
        pcall(function() vehicleUI.Visible = true end)
        vehicleUI = nil
    end

    startPos = nil
end

local function open()
    if not _G.Functions.isPlayerInOwnCar() then
        _G.Functions.notif("Map", "Get in your car first", 3)
        return
    end

    local car = _G.Functions.getPlayerCar()
    if not car then return end

    active = true
    streamClock = 0
    dragging = false
    trackTarget = nil

    local origin = car:GetPivot().Position
    camX = origin.X
    camZ = origin.Z
    camHeight = 600
    targetHeight = 600

    startPos = car:GetPivot().Position

    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
    holdCar(car)

    pcall(function()
        vehicleUI = lp.PlayerGui.GameGui.VehicleGui["Vehicle Interface"]
        vehicleUI.Visible = false
    end)

    -- Smooth zoom with scroll wheel
    table.insert(sessionConns, userInput.InputChanged:Connect(function(input)
        if not active then return end
        if input.UserInputType == Enum.UserInputType.MouseWheel then
            local dir = input.Position.Z
            targetHeight = math.clamp(targetHeight * (1 - dir * 0.15), 30, 1500)
        end
    end))

    -- Right-click drag start
    table.insert(sessionConns, userInput.InputBegan:Connect(function(input, gp)
        if gp or not active then return end
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            dragging = true
            dragOrigin = userInput:GetMouseLocation()
        end
    end))

    -- Right-click drag end
    table.insert(sessionConns, userInput.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            dragging = false
        end
    end))

    -- T to teleport car to cursor and close map
    table.insert(sessionConns, userInput.InputBegan:Connect(function(input, gp)
        if gp or not active then return end
        if input.KeyCode == Enum.KeyCode.T then
            close(groundHit)
        end
    end))

    -- Left-click to track/untrack vehicles
    table.insert(sessionConns, userInput.InputBegan:Connect(function(input, gp)
        if gp or not active then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if trackTarget then
                trackTarget = nil
                _G.Functions.notif("Map", "Stopped tracking", 2)
            else
                local vehicle = findVehicleAtCursor()
                if vehicle then
                    trackTarget = vehicle
                    local owner = vehicle:GetAttribute("Owner") or vehicle.Name
                    _G.Functions.notif("Map", "Tracking: " .. owner, 2)
                end
            end
        end
    end))

    -- Render loop: camera positioning + ground raycast
    table.insert(sessionConns, runService.RenderStepped:Connect(function(dt)
        if not active then return end

        camHeight = camHeight + (targetHeight - camHeight) * math.min(dt * 8, 1)

        workspace.CurrentCamera.CFrame = CFrame.new(camX, camHeight, camZ)
            * CFrame.Angles(-math.pi / 2, 0, 0)

        groundHit = raycastGround(workspace.CurrentCamera)
    end))

    -- Physics loop: pan, drag, track, hold car, stream
    table.insert(sessionConns, runService.Heartbeat:Connect(function(dt)
        if not active then return end

        local car = _G.Functions.getPlayerCar()
        if not car then
            close()
            return
        end

        holdCar(car)

        -- Follow tracked target
        if trackTarget and trackTarget.Parent then
            local tPos
            if trackTarget:IsA("Model") then
                tPos = trackTarget:GetPivot().Position
            elseif trackTarget:IsA("BasePart") then
                tPos = trackTarget.Position
            end
            if tPos then
                camX = camX + (tPos.X - camX) * math.min(dt * 5, 1)
                camZ = camZ + (tPos.Z - camZ) * math.min(dt * 5, 1)
            end
        elseif trackTarget and not trackTarget.Parent then
            trackTarget = nil
            _G.Functions.notif("Map", "Target lost", 2)
        end

        -- WASD panning (stops tracking)
        local speed = math.max(camHeight * 0.9, 60)
        local panning = false
        if userInput:IsKeyDown(Enum.KeyCode.W) then camZ -= speed * dt; panning = true end
        if userInput:IsKeyDown(Enum.KeyCode.S) then camZ += speed * dt; panning = true end
        if userInput:IsKeyDown(Enum.KeyCode.A) then camX -= speed * dt; panning = true end
        if userInput:IsKeyDown(Enum.KeyCode.D) then camX += speed * dt; panning = true end
        if panning and trackTarget then
            trackTarget = nil
        end

        -- Right-click drag panning
        if dragging then
            local now = userInput:GetMouseLocation()
            local delta = now - dragOrigin
            local cam = workspace.CurrentCamera
            local vp = cam.ViewportSize
            local focalLen = vp.Y / (2 * math.tan(math.rad(cam.FieldOfView / 2)))
            local scale = camHeight / focalLen
            camX -= delta.X * scale
            camZ -= delta.Y * scale
            dragOrigin = now
            if trackTarget then trackTarget = nil end
        end

        -- Stream around camera periodically
        streamClock += dt
        if streamClock >= 1.5 then
            streamClock = 0
            local x, z = camX, camZ
            task.spawn(function()
                pcall(function() lp:RequestStreamAroundAsync(Vector3.new(x, 0, z), 3) end)
            end)
        end
    end))
end

-- UI Controls

local mapToggle = mapTab:Toggle({
    Title = "Enable Map View",
    Desc = "Opens a top-down map view of the world",
    Default = false,
    Callback = function(state)
        if state then
            open()
            if not active then
                mapToggle:Set(false)
            end
        else
            close()
        end
    end,
})

mapTab:Keybind({
    Title = "Map Keybind",
    Desc = "Key to toggle the map view",
    Value = "J",
    Callback = function(v)
        currentMapKeybind = Enum.KeyCode[v]
    end,
})

mapTab:Toggle({
    Title = "Enable Keybind",
    Desc = "Allow toggling map with the keybind",
    Default = true,
    Callback = function(state)
        mapKeybindEnabled = state
    end,
})

mapTab:Section({ Title = "Controls" })

mapTab:Paragraph({
    Title = "Map Controls",
    Desc = "WASD - Pan camera\nScroll - Zoom in/out\nRight-click drag - Drag pan\nLeft-click - Track a vehicle\nT - Teleport to cursor and close\nKeybind - Toggle map on/off",
})

-- Keybind listener
userInput.InputBegan:Connect(function(input, gp)
    if gp then return end
    if mapKeybindEnabled and input.KeyCode == currentMapKeybind then
        if active then
            mapToggle:Set(false)
        else
            mapToggle:Set(true)
        end
    end
end)
