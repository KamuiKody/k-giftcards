local QBCore = exports["qb-core"]:GetCoreObject()
local commission = 0

RegisterServerEvent('k-giftcard:buygiftcard', function(value,label,job,dirty)
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
	if not dirty then
		if not Player.Functions.RemoveMoney('cash', value) then return TriggerClientEvent('QBCore:Notify', _source, 'Not enough money', 'error') end
        local info = {
            storename = label,
            worth = value,
            job = job
        }
        Player.Functions.AddItem(Config.ItemName, 1, false, info)
        TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.ItemName], "add")		
	else
		local markedbills = Player.Functions.GetItemByName('markedbills')
		if not markedbills then return TriggerClientEvent('QBCore:Notify', _source, 'Not enough money', 'error') end
		local worth = (math.floor(markedbills.info.worth * Config.MarkedMult) * 1)
		if worth > value then
			local itemSlot = markedbills.slot
			local newWorth = tonumber(worth - value)
			Player.PlayerData.items[itemSlot].info.worth = newWorth
			Player.Functions.SetInventory(Player.PlayerData.items, true)
			local info = {
                storename = label,
                worth = value,
                job = job
            }
            Player.Functions.AddItem(Config.ItemName, 1, false, info)
            TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[Config.ItemName], "add")	
		else
			TriggerClientEvent('QBCore:Notify', _source, 'Not enough money', 'error')
		end
	end
end)

RegisterServerEvent('k-giftcards:jobcheck', function(job, value, closestPlayer, item, label)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetData = QBCore.Functions.GetPlayer(closestPlayer)
    if TargetData.PlayerData.job.name == job then 
        TriggerClientEvent('k-giftcards:priceset', closestPlayer, job, value, closestPlayer, src, item, label)
    else
        TriggerClientEvent('QBCore:Notify', src, 'The Closest Target Doesnt Have that job.', 'error')
    end
end)


RegisterServerEvent('k-giftcards:priceset1', function(price, job, value, target, originalply, item, label)
    TriggerClientEvent('k-giftcard:swipeui', originalply, price, job, value, target, originalply, item, label)
end)

RegisterServerEvent('k-giftcard:squareup', function(data)
    local src = source
    local target = data.target
    local item = data.item
    local value = data.value
    local label = item.info.storename
    local job = data.job
    local price = data.price
    local itemSlot = item.slot
    local Player = QBCore.Functions.GetPlayer(src)
    local TargetData = QBCore.Functions.GetPlayer(target)
    if item.info.worth < price then
        TriggerClientEvent('QBCore:Notify', src, 'Not enough on the card...', 'error')
        TriggerClientEvent('QBCore:Notify', target, 'Not enough on the card...', 'error')
    elseif item.info.worth == price then
        Player.Functions.RemoveItem(item.name, 1, item.slot)    
        TriggerClientEvent("inventory:client:ItemBox", QBCore.Shared.Items[item.name], "remove")
        for k,v in pairs(Config.CardTypes) do
            local name = tostring(v.jobname)
            if name == tostring(job) then
                commission = (math.floor(price * Config.CardTypes[k].commission) * 1)
            end
        end
        exports['qb-management']:AddMoney(job, price - commission)
        TargetData.Functions.AddMoney('bank', commission)
    else
        Player.Functions.RemoveItem(item.name, 1, item.slot)    
        local info = {
            storename = label,
            worth = value - price,
            job = job
        }
        Player.Functions.AddItem(item.name, 1, item.slot, info)
        Player.PlayerData.items[itemSlot].info.worth = value - price
        for k,v in pairs(Config.CardTypes) do
            local name = tostring(v.jobname)
            if name == tostring(job) then
                commission = (math.floor(price * Config.CardTypes[k].commission) * 1)
            end
        end
        exports['qb-management']:AddMoney(job, price - commission)
        TargetData.Functions.AddMoney('bank', commission)
    end
end)

RegisterServerEvent('k-giftcard:deny', function(data)
    local src = data.originalply
    local target = data.target
    TriggerClientEvent('QBCore:Notify', src, 'You canceled the transaction.', 'error')
    TriggerClientEvent('QBCore:Notify', target, 'Buyer canceled the transaction.', 'error')
end)

QBCore.Functions.CreateUseableItem(Config.ItemName, function(source, item)
    local job = item.info.job
    local value = item.info.worth
    local label = item.info.storename
    local src = source
    TriggerClientEvent('k-giftcards:usecard', src, job, value, item, label)
end)