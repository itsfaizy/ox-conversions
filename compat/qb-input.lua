local function exportHandler(exportName, func)
    AddEventHandler(('__cfx_export_qb-input_%s'):format(exportName), function(setCB) setCB(func) end)
end

local function convertToOx(data)
    local name = data.header
    local oxData = {}
    local names = {}
    local required = {}
    local nextLabel = nil
    for k, v in ipairs(data.inputs) do
        if v.isRequired then required[k] = true end
        if v.type == 'text' then
            oxData[#oxData + 1] = {
                type = 'input',
                placeholder = v.text,
                default = v.default,
                label = nextLabel
            }
            names[#oxData] = v.name
            if nextLabel then nextLabel = nil end
        elseif v.type == 'number' then
            oxData[#oxData + 1] = {
                type = 'number',
                placeholder = v.text,
                default = v.default,
                label = nextLabel
            }
            names[#oxData] = v.name
            if nextLabel then nextLabel = nil end
        elseif v.type == 'password' then
            oxData[#oxData + 1] = {
                type = 'input',
                placeholder = v.text,
                icon = 'lock',
                password = true,
                label = nextLabel
            }
            names[#oxData] = v.name
            if nextLabel then nextLabel = nil end
        elseif v.type == 'radio' then
            oxData[#oxData + 1] = {
                type = 'select',
                label = v.text
            }
            for _, option in ipairs(v.options) do
                oxData[#oxData].options = oxData[#oxData].options or {}
                oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                    label = option.text,
                    value = option.value
                }
            end
            names[#oxData] = v.name
            if nextLabel then nextLabel = nil end
        elseif v.type == 'checkbox' then
            if #v.options == 1 then
                oxData[#oxData + 1] = {
                    type = 'checkbox',
                    label = v.text,
                    default = v.default,
                    checked = v.options[1].checked
                }
                names[k] = v.options[1].value
                if nextLabel then nextLabel = nil end
            elseif #v.options == 0 then
                -- I would sometimes do this to make a subheader - Mkeefeus
                nextLabel = v.text
            else
                -- fallback to qb-input
                -- return ShowInput(data, true)
                return lib.notify({
                    title = 'Error',
                    description = 'Error',
                    type = 'error'
                })
            end
        elseif v.type == 'select' then
            oxData[#oxData + 1] = {
                type = 'select',
                label = v.text
            }
            for _, option in ipairs(v.options) do
                oxData[#oxData].options = oxData[#oxData].options or {}
                oxData[#oxData].options[#oxData[#oxData].options + 1] = {
                    label = option.text,
                    value = option.value
                }
            end
            names[#oxData] = v.name
            if nextLabel then nextLabel = nil end
        end
    end
    local selections = lib.inputDialog(name, oxData)
    if not selections then return end
    local returnData = {}
    for k, v in pairs(selections) do
        if required[k] and (not v or v == '') then
            lib.notify({
                title = 'Error',
                description = 'You must fill out all required fields',
                type = 'error'
            })
            return lib.inputDialog(name, oxData)
        end
        returnData[names[k]] = tostring(v)
    end
    return next(returnData) and returnData or nil
end

exportHandler('ShowInput', function(data) return convertToOx(data) end)
