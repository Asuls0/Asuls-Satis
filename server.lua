local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('shop:hasIllegalCard', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local hasCard = Player.Functions.GetItemByName(Config.IllegalCard) ~= nil
    cb(hasCard)
end)

QBCore.Functions.CreateCallback('shop:processBargain', function(source, cb, originalPrice, offeredPrice)
    local difficulty = Config.BargainDifficulty
    local success = math.random() > difficulty and offeredPrice >= originalPrice
    cb(success)
end)

RegisterServerEvent("shop:processPurchase")
AddEventHandler("shop:processPurchase", function(itemName, quantity, price)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local totalPrice = price * quantity

    if Player.Functions.RemoveMoney('cash', totalPrice, "item-purchase") then
        Player.Functions.AddItem(itemName, quantity)
        TriggerClientEvent("QBCore:Notify", src, string.format("Başarıyla %d adet %s satın aldınız!", quantity, itemName), "success")
    else
        TriggerClientEvent("QBCore:Notify", src, "Yetersiz bakiye!", "error")
    end
end)
