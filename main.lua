QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateUseableItem('stickynotepad', function(source, item)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)			
	local itemData = Player.Functions.GetItemBySlot(item.slot)
	if itemData.info.text ~= nil then 
		TriggerClientEvent('stickynotepad:client:showUI', src,  itemData.info.text, item.slot)
	else
		TriggerClientEvent('stickynotepad:client:showUI', src, 'Type Here...', item.slot)
	end
end)

RegisterServerEvent("jake:server:stickychange")
AddEventHandler("jake:server:stickychange", function(text, slot)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)	
	local stickynote = Player.Functions.GetItemBySlot(slot)
	
	if Player.Functions.RemoveItem('stickynotepad', 1, slot) then
		local info = {}
		info.text = text
		Player.Functions.AddItem('stickynotepad', 1, false, info)
	end
end)