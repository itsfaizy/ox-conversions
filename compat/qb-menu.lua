local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-menu_%s'):format(exportName), function(setCB) setCB(func) end)
end

local function convertToOx(data)
    local qbmenuID = 'qbmenu_convert'
    local oxData = {
        id = qbmenuID,
        title = nil,
        onExit = function()
            if curCB then
                curCB(nil)
                curCB = nil
            end
        end,
        options = nil
    }
    local options = {}
    for _, v in ipairs(data) do
        -- Formmating conversion
        if v.hidden then goto continue end
        if v.isMenuHeader and not oxData.title and not v.txt then
            oxData.title = v.header
        elseif v.isMenuHeader then
            options[#options + 1] = {
                title = v.header,
                description = v.txt,
            }
        else
            options[#options + 1] = {
                title = v.header,
                icon = v.icon,
                description = v.txt,
                disabled = v.disabled,
                metadata =  v.image,
                image =  v.image,
                onSelect = function()
                    if v.params.isServer then
                        TriggerServerEvent(v.params.event, v.params.args)
                    else
                        TriggerEvent(v.params.event, v.params.args)
                    end
                end
            }
        end
        ::continue::
    end
    if not oxData.title then
        oxData.title = 'Menu'
    end
    oxData.options = options
    lib.registerContext(oxData)     
    lib.showContext(qbmenuID)
    return oxData
end

local function showHeader(data)
    convertToOx(data)
end

local function closeMenu()
    lib.hideContext()
end

-- Events

RegisterNetEvent('qb-menu:client:openMenu', function(data)
    convertToOx(data)
end)

RegisterNetEvent('qb-menu:client:closeMenu', closeMenu)

RegisterNetEvent('qb-menu:closeMenu', closeMenu)

-- Exports

--exports('openMenu', openMenu)
exportHandler('openMenu', function(data) return convertToOx(data) end)
exportHandler('closeMenu', function(data) return closeMenu() end)
exportHandler('showHeader', function(data) return showHeader(data) end)