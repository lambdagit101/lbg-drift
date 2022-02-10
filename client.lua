--values you can play around with
--this makes the drift a toggle. set to false to require holding for drifting,
--much like vMenu's drifting
local driftIsToggle = false
--if the value above is false, this control is used to drift
--check https://docs.fivem.net/docs/game-references/controls/ for more info
local controlIfToggleDisabled = 21

--actual coding stuff
local globalDriftState = false

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function ChangeDrift(bool)
    local playerPed = PlayerPedId()
    local playerVehicle = GetVehiclePedIsIn(playerPed, false)
    if playerVehicle ~= 0 and IsVehicleOnAllWheels(playerVehicle) and GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
        globalDriftState = bool
        SetDriftTyresEnabled(playerVehicle, globalDriftState)
        SetReduceDriftVehicleSuspension(playerVehicle, globalDriftState)
        if globalDriftState then
            ShowNotification("~b~Drift is ~g~ON")
        else
            ShowNotification("~b~Drift is ~r~OFF")
        end
    end
end

if driftIsToggle then
    RegisterCommand("toggledrift", function()
        local playerPed = PlayerPedId()
        local playerVehicle = GetVehiclePedIsIn(playerPed, false)
        ChangeDrift(not GetDriftTyresEnabled(playerVehicle))
    end)
    RegisterKeyMapping("toggledrift", "Toggle Drift", "keyboard", "lshift")
else
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            if IsControlJustPressed(0, controlIfToggleDisabled) then
                ChangeDrift(true)
            end
            if IsControlJustReleased(0, controlIfToggleDisabled) then
                ChangeDrift(false)
            end
        end
    end)
end
