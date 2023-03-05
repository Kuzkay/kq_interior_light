Citizen.CreateThread(function()
    local input = Config.keybinds.toggle.input
    local pressedAt = nil
    
    while true do
        local sleep = 3000
        
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed) then
            local veh = GetVehiclePedIsIn(playerPed)
            
            -- Whether or not the ped is the driver
            if GetPedInVehicleSeat(veh, -1) == playerPed then
                sleep = 50
                
                if IsControlPressed(0, input) or IsDisabledControlPressed(0, input) then
                    if pressedAt == nil then
                        pressedAt = GetGameTimer()
                    elseif pressedAt + 100 < GetGameTimer() then
                        -- This will disable the headlight control when the keybind is pressed down. By having the 100ms
                        -- of threshold the headlight control will still function normally when clicked (not pressed)
                        sleep = 1
                        DisableControlAction(0, input)
                    end
                    
                    if pressedAt + Config.keybinds.toggle.holdDuration < GetGameTimer() then
                        pressedAt = nil
                        local netId = NetworkGetNetworkIdFromEntity(veh)
                        TriggerServerEvent('kq_interior_light:server:set', netId, not IsVehicleInteriorLightOn(veh))
                        
                        Citizen.CreateThread(function()
                            local disableUntil = GetGameTimer() + 100
                            while GetGameTimer() < disableUntil do
                                Citizen.Wait(1)
                                DisableControlAction(0, input)
                            end
                        end)
                    end
                else
                    pressedAt = nil
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

AddStateBagChangeHandler('kq_interior_light', nil, function(bagName, key, value)
    local entity = GetEntityFromStateBagName(bagName)
    if entity == 0 then
        return
    end
    
    SetVehicleInteriorlight(entity, value)
end)
