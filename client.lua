local isScrapping = false

local function toggleText(show, text)
    if not lib then return end
    if show then
        lib.showTextUI(text, {position = "right-center"})
    else
        lib.hideTextUI()
    end
end

CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        
        if Config and Config.ScrapCoords then
            local dist = #(coords - Config.ScrapCoords)

            if dist < 15.0 then
                sleep = 0
                DrawMarker(1, Config.ScrapCoords.x, Config.ScrapCoords.y, Config.ScrapCoords.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 3.0, 3.0, 1.0, 255, 0, 0, 100, false, false, 2, false, nil, nil, false)

                if dist < Config.ScrapDistance and not isScrapping then
                    local vehicle = GetVehiclePedIsIn(playerPed, false)
                    
                    if vehicle ~= 0 then
                        toggleText(true, '[E] - Scrap Vehicle')
                        if IsControlJustReleased(0, 38) then
                            StartScrapping(vehicle)
                        end
                    else
                        toggleText(true, 'You have to sit in the vehicle!')
                    end
                else
                    toggleText(false)
                end
            end
        end
        Wait(sleep)
    end
end)

function StartScrapping(vehicle)
    local coords = GetEntityCoords(vehicle)
    isScrapping = true
    toggleText(false)

    if lib.progressBar({
        duration = Config.ScrapTime,
        label = 'Scraping Vehicle...',
        useWhileDead = false,
        canCancel = true,
        disable = { car = true, move = true, combat = true }
    }) then 
        TriggerServerEvent('ykaa_scrap:giveItem', coords)
        
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
        
        lib.notify({ title = 'Scrapyard', description = 'The vehicle was successfully scrapped.', type = 'success' })
    else
        lib.notify({ title = 'Cancelled', description = 'Scrapping has been interrupted.', type = 'error' })
    end
    
    isScrapping = false
end