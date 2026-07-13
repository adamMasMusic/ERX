local runService = game:GetService("RunService")
local players = game:GetService("Players")
local lp = players.LocalPlayer

repeat task.wait() until _G.Functions and _G.WindUI

local WindUI = _G.WindUI

_G.Functions.notif = function(title: string, text: string, time: number)
    WindUI:Notify({
    	Title = title or "QoL",
    	Content = text or "No text",
    	Duration = time or 3,
    })
end

_G.Functions.getChar = function() : Model
    local char = lp.Character or lp.CharacterAdded:Wait()
    return char
end

_G.Functions.getPlayerCar = function() : Model
    local char = _G.Functions.getChar()
    if char:FindFirstChild("Humanoid") and char.Humanoid.SeatPart and char.Humanoid.SeatPart.Name == "DriverSeat" then
        return char.Humanoid.SeatPart.Parent
    end
    for _, car in workspace.Vehicles:GetChildren() do
        if car:GetAttribute("Owner") == lp.Name then
            return car
        end
    end
    for _, atv in workspace.ATVs:GetChildren() do
        if atv:GetAttribute("Owner") == lp.Name then
            return atv
        end
    end
    return nil
end

_G.Functions.isPlayerInOwnCar = function() : boolean
    local char = _G.Functions.getChar()
    if char.Humanoid.SeatPart and char.Humanoid.SeatPart.Parent:GetAttribute("Owner") == lp.Name then
        return true
    else
        return false
    end
end

_G.Functions.togglePlayerCar = function(status: boolean) : boolean
    if
        lp.PlayerGui.GameGui.VehicleGui and
        lp.PlayerGui.GameGui.VehicleGui:FindFirstChild("Vehicle Interface") and
        lp.PlayerGui.GameGui.VehicleGui["Vehicle Interface"]:FindFirstChild("IsOn")
    then
        lp.PlayerGui.GameGui.VehicleGui["Vehicle Interface"].IsOn.Value = status
        return true
    end
    return false
end

_G.Functions.isDriving = function() : boolean
    local gameGui = lp.PlayerGui:FindFirstChild("GameGui")
    if not gameGui then return false end
    local vehicleGui = gameGui:FindFirstChild("VehicleGui")
    if not vehicleGui then return false end
    return vehicleGui:FindFirstChild("Vehicle Interface") ~= nil
end

_G.Functions.getController = function()
    local car = _G.Functions.getPlayerCar()
    if not car then return nil end
    local module = car:FindFirstChild("Drive Controller")
    if not module then return nil end
    return require(module)
end

local weights = {}
local saved = {}
local weightsCar = nil

_G.Functions.makeWeightlessCar = function(toggle: boolean)
    local car = _G.Functions.getPlayerCar()
    if not car or (not toggle and next(saved) == nil) then return false end

    if weightsCar ~= car and not toggle then
        weightsCar = nil
        weights = {}
        saved = {}
        return false
    end

    weightsCar = car

    for _, item in car.Body:GetChildren() do
        if item:IsA("BasePart") then
            if toggle then
                if not saved[item] then
                    saved[item] = true
                    weights[item] = item.CustomPhysicalProperties
                end
                local old = item.CurrentPhysicalProperties
                item.CustomPhysicalProperties = PhysicalProperties.new(
                    0,
                    old.Friction,
                    old.Elasticity,
                    old.FrictionWeight,
                    old.ElasticityWeight
                )
            else
                item.CustomPhysicalProperties = weights[item]
            end
        end
    end

    if not toggle then
        weightsCar = nil
        weights = {}
        saved = {}
    end

    return true
end

_G.Functions.applyCamber = function(wheel: Instance, camber: number)
    local sideLetter = string.sub(wheel.Name, 2, 2)
    local isRight = (sideLetter == "R")

    local aa = wheel.AxleP.AA
    local ba = wheel.AxleP.BA

    local radians = math.rad(camber)

    local yMultiplier = isRight and -1 or 1

    local y = math.cos(radians) * yMultiplier
    local z = math.sin(radians) * yMultiplier

    local newAxis = Vector3.new(0, y, z)

    aa.Axis = newAxis
    ba.Axis = newAxis
end

_G.Functions.applyToe = function(wheel: Instance, toe: number)
    local isRight = (string.sub(wheel.Name, 2, 2) == "R")
    local sideMul = isRight and -1 or 1
    local aa, ba = wheel.AxleP.AA, wheel.AxleP.BA

    local rot = CFrame.Angles(0, math.rad(toe * sideMul), 0)
    local newAxis = (rot * Vector3.new(0, 1, 0)) * sideMul

    aa.Axis = newAxis
    ba.Axis = newAxis
end

_G.Functions.applyCaster = function(wheel: Instance, caster: number)
    local isRight = (string.sub(wheel.Name, 2, 2) == "R")
    local sideMul = isRight and -1 or 1
    local aa, ba = wheel.AxleP.AA, wheel.AxleP.BA

    local rot = CFrame.Angles(math.rad(caster * sideMul), 0, 0)
    local newAxis = (rot * Vector3.new(0, 1, 0)) * sideMul

    aa.Axis = newAxis
    ba.Axis = newAxis
end

local weldCache = {}

local function ensureCache(wheel)
    local cached = weldCache[wheel]
    if cached and not cached.weld.Parent then
        weldCache[wheel] = nil
        cached = nil
    end
    if not cached then
        local sa = wheel:FindFirstChild("#SA")
        if not sa then return nil end
        local car = _G.Functions.getPlayerCar()
        if not car then return nil end
        local seat = car:FindFirstChild("DriverSeat")
        if not seat then return nil end
        local weld
        for _, child in seat:GetChildren() do
            if child:IsA("Weld") and child.Part1 == sa then
                weld = child
                break
            end
        end
        if not weld then return nil end
        cached = {
            weld = weld,
            origLocal = weld.C0 * weld.C1:Inverse(),
            offsets = { X = 0, Y = 0, Z = 0 },
        }
        weldCache[wheel] = cached
    end
    return cached
end

_G.Functions.applyAxleOffset = function(wheel, offsets)
    local cached = ensureCache(wheel)
    if not cached then return end

    if offsets.X ~= nil then cached.offsets.X = offsets.X end
    if offsets.Y ~= nil then cached.offsets.Y = offsets.Y end
    if offsets.Z ~= nil then cached.offsets.Z = offsets.Z end

    local isRight = (string.sub(wheel.Name, 2, 2) == "R")
    local wm = isRight and 1 or -1

    local delta = Vector3.new(
        cached.offsets.X * wm,
        cached.offsets.Y,
        cached.offsets.Z
    )
    local newLocal = cached.origLocal + delta
    cached.weld.C1 = newLocal:Inverse() * cached.weld.C0
end

_G.Functions.setWheelPosition = function(wheel, position, pivot)
    local cached = ensureCache(wheel)
    if not cached then return end

    local car = _G.Functions.getPlayerCar()
    if not car then return end

    local seat = car:FindFirstChild("DriverSeat")
    if not seat then return end

    local center = pivot or seat.Position
    local offset = Vector3.new(
        position.X or 0,
        position.Y or 0,
        position.Z or 0
    )

    local targetWorld = CFrame.new(center + offset)

    cached.weld.C1 = targetWorld:Inverse() * seat.CFrame * cached.weld.C0
end

_G.Functions.setWheelWorldPosition = function(wheel, worldPosition)
    local cached = ensureCache(wheel)
    if not cached then return end

    local car = _G.Functions.getPlayerCar()
    if not car then return end

    local seat = car:FindFirstChild("DriverSeat")
    if not seat then return end

    local targetWorld = CFrame.new(worldPosition)
    cached.weld.C1 = targetWorld:Inverse() * seat.CFrame * cached.weld.C0
end

local steeringInverted = false
local steeringInvertedCar = nil
_G.Functions.invertSteering = function()
    if not _G.Functions.isDriving() then return end
    local car = _G.Functions.getPlayerCar()

    if steeringInvertedCar ~= car then
        steeringInverted = false
        steeringInvertedCar = car
    end
    local ctrl = _G.Functions.getController()
    if not ctrl then return end
    local controls = ctrl.Controls
    if steeringInverted then
        if controls._origSteerLeft then
            controls.SteerLeft = controls._origSteerLeft
            controls.SteerRight = controls._origSteerRight
        end
        if controls._origSteerLeft2 then
            controls.SteerLeft2 = controls._origSteerLeft2
            controls.SteerRight2 = controls._origSteerRight2
        end
        _G.Functions.notif(nil, "Steering restored", 2)
    else
        local origLeft = controls._origSteerLeft or controls.SteerLeft
        local origRight = controls._origSteerRight or controls.SteerRight
        controls._origSteerLeft = origLeft
        controls._origSteerRight = origRight
        controls.SteerLeft = origRight
        controls.SteerRight = origLeft
        
        if controls.SteerLeft2 and controls.SteerRight2 then
            local origLeft2 = controls._origSteerLeft2 or controls.SteerLeft2
            local origRight2 = controls._origSteerRight2 or controls.SteerRight2
            controls._origSteerLeft2 = origLeft2
            controls._origSteerRight2 = origRight2
            controls.SteerLeft2 = origRight2
            controls.SteerRight2 = origLeft2
        end
        _G.Functions.notif(nil, "Steering inverted", 2)
    end
    steeringInverted = not steeringInverted
end

_G.ExtraFuctions = true

_G.CarAntiVoid = false
_G.FreezePosition = Vector3.zero
_G.FreezeCar = false
if _G.extraConnection then
    _G.extraConnection:Disconnect()
end
_G.extraConnection = runService.Heartbeat:Connect(function(dt: number)
    if _G.FreezeCar and _G.Functions.isDriving() then
        local car = _G.Functions.getPlayerCar()
        if not car then return end

        if _G.FreezePosition == CFrame.identity then
            _G.FreezePosition = car:GetPivot()
        end

        local primary = car.PrimaryPart
        primary.AssemblyLinearVelocity = Vector3.zero
        primary.AssemblyAngularVelocity = Vector3.zero
        car:PivotTo(_G.FreezePosition)
    else
        _G.FreezePosition = CFrame.identity
    end
    if _G.CarAntiVoid and _G.Functions.isDriving() then
        local car = _G.Functions.getPlayerCar()
        if not car then return end

        local pos = car:GetPivot()
        if pos.Position.Y < -400 then
            local primary = car.PrimaryPart
            primary.AssemblyLinearVelocity = Vector3.zero
            primary.AssemblyAngularVelocity = Vector3.zero
            car:PivotTo(CFrame.new(pos.Position.X, -200, pos.Position.Z))
        end
    end
end)
