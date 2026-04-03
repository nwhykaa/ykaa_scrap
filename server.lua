local ESX = exports['es_extended']:getSharedObject()

RegisterNetEvent('ykaa_scrap:giveItem')
AddEventHandler('ykaa_scrap:giveItem', function(coords)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    
    if xPlayer then
        local count = math.random(1, 3)
        
        local added = exports.ox_inventory:AddItem(src, Config.Item, count)
        
        if added then
            print('^2[ykaa_scrap]^7 Player ' .. GetPlayerName(src) .. ' got ' .. count .. 'x ' .. Config.Item)
            TriggerClientEvent('ox_lib:notify', src, {type = 'success', description = 'You got '..count..'x '..Config.Item})
        else
            print('^1[ykaa_scrap ERROR]^7 Failed to add item! Check if item "' .. Config.Item .. '" located in ox_inventory/data/items.lua')
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'Chyba: Předmět "'..Config.Item..'" neexistuje nebo máš plný inventář!'})
        end

        if math.random(1, 100) <= Config.DispatchChance then
            TriggerClientEvent('cd_dispatch:AddNotification', -1, {
                job_table = Config.Jobs,
                coords = coords,
                title = "10-83 - Scrapping Vehicle",
                message = "Suspicious activity has been reported at the junkyard!", 
                flash = 0,
                unique_id = tostring(math.random(000000, 999999)),
                blip = { 
                    sprite = 524, 
                    scale = 1.0, 
                    colour = 1, 
                    flashes = true, 
                    text = 'Scrapping Vehicle', 
                    time = 5, 
                    radius = 50, 
                    sound = 1
                }
            })
        end
    end
end)
