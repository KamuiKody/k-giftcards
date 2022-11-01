local QBCore = exports["qb-core"]:GetCoreObject()
local propSpawned = false
local ShopPed = nil
local prop = {} 
local pedSpawned = false
local temptable = {}

CreateThread(function()
    for k,v in pairs(Config.Buy) do
    local x, y, z, w = table.unpack(v['coords'])
    exports['qb-target']:AddBoxZone('Stall '.. k, vector3(x, y, z), 2, 2, {
        name='Stall '.. k,
        heading=heading,
        --debugPoly=true
            }, {
        options = {
            {
                type = "client",
                event = "k-giftcard:buymenu",
                icon = "fas fa-credit-card",
                label = v['targetLabel'],
                dirty = v['UseDirty']
            },
        },
        distance = 2.5
    }) 
    end
end)


RegisterNetEvent('k-giftcard:buymenu', function(data)
    if data.dirty then
        local dirtyoptions = {
            {
                header = "| Use Dirty Money? |",
                isMenuHeader = true
            },
            {
                header = "Use Dirty Money",
                params = {
                    event = 'k-giftcard:opencardshop',
                    args = {
                        dirty = true
                    }
                }
            },
            {
                header = "Use Cash",
                params = {
                    event = 'k-giftcard:opencardshop',
                    args = {
                        dirty = false
                    }
                }
            }
            

        }
        exports['qb-menu']:openMenu(dirtyoptions)
    else
        local data = {
            dirty = false
        }
        TriggerEvent('k-giftcard:opencardshop', data)
    end
end)

RegisterNetEvent('k-giftcard:opencardshop', function(data)
    local dirty = data.dirty
    local storeoptions = {
        {
            header = "| Gift Card Rack |",
            isMenuHeader = true
        }
    }
    for k,v in pairs(Config.CardTypes) do
        storeoptions[#storeoptions + 1] = {
            header = v.label,
            params = {
                event = "k-giftcard:cardchoose",
                args = {
                    job = v.jobname,
                    label = v.label,
                    dirty = dirty
                    }
                }

        }
    end
    exports['qb-menu']:openMenu(storeoptions)
end)

RegisterNetEvent("k-giftcard:cardchoose", function(data)
    local label = data.label
    local dialog = exports['qb-input']:ShowInput({
        header = label .."  Gift Card Value",
        submitText = "submit",
        inputs = {
            {
                text = "Amount",
                name = "Amount",
                type = "text",
                isRequired = true
            }
        }
    })
    if dialog ~= nil then
        local entry = (dialog['Amount'])
        TriggerServerEvent('k-giftcard:buygiftcard', tonumber(entry), label, data.job, data.dirty)
    else
        QBCore.Functions.Notify('You must set a valid amount!', 'error', 5000)
    end
end)

RegisterNetEvent('k-giftcards:usecard', function(job, value, item, label)
    local dialog = exports['qb-input']:ShowInput({
        header = "| Sales Person ID |",
        submitText = "submit",
        inputs = {
            {
                text = "Amount",
                name = "Amount",
                type = "text",
                isRequired = true
            }
        }
    })
    if dialog ~= nil then
        local entry = (dialog['Amount'])
        TriggerServerEvent('k-giftcards:jobcheck', job, value, tonumber(entry), item, label)
    else
        QBCore.Functions.Notify('You must set a valid amount!', 'error', 5000)
    end        
end)


RegisterNetEvent('k-giftcards:priceset', function(job, value, target, originalply, item, label)
    local dialog = exports['qb-input']:ShowInput({
        header = "| Charge Amount |",
        submitText = "submit",
        inputs = {
            {
                text = "Amount",
                name = "Amount",
                type = "text",
                isRequired = true
            }
        }
    })
    if dialog ~= nil then
        local entry = (dialog['Amount'])
        if tonumber(entry) <= value then
            TriggerServerEvent('k-giftcards:priceset1', tonumber(entry), job, value, target, originalply, item, label)    
        else
            QBCore.Functions.Notify('There is not enough on their card for that', 'error', 5000)
        end
    else
        QBCore.Functions.Notify('You must set a valid amount!', 'error', 5000)
    end
end)


RegisterNetEvent('k-giftcard:swipeui', function(price, job, value, target, originalply, item, label)
    local dirtyoptions = {
        {
            header = "| Transaction Amount: $"..price.." |",
            isMenuHeader = true
        },
        {
            header = "Accept!",
            params = {
                event = 'k-giftcard:accept',
                args = {
                   price = price, 
                   job = job, 
                   value = value, 
                   target = target, 
                   originalply = originalply, 
                   item = item, 
                   label = label
                }
            }
        },
        {
            header = "Deny!",
            params = {
                event = 'k-giftcard:close',
                args = {
                    target = target, 
                    originalply = originalply
                }
            }
        }
    }
    exports['qb-menu']:openMenu(dirtyoptions)
end)

RegisterNetEvent('k-giftcard:close', function(data)
    TriggerServerEvent('k-giftcard:deny', data)
end)


RegisterNetEvent('k-giftcard:accept', function(data)
    TriggerServerEvent('k-giftcard:squareup', data)
    QBCore.Functions.Notify('$'..data.price..' was removed from your '..data.label..' giftcard!', 'success', 5000)
end)