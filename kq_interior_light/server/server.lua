RegisterServerEvent('kq_interior_light:server:set')
AddEventHandler('kq_interior_light:server:set', function(netId, value)
    local _source = source
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    
    if not DoesEntityExist(vehicle) then
        return
    end
    
    Entity(vehicle).state.kq_interior_light = value
end)
