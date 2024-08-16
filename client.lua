local QBCore = exports['qb-core']:GetCoreObject()

CreateThread(function()
    for _, v in pairs(Config.Peds) do
        RequestModel(v.ped)
        while not HasModelLoaded(v.ped) do
            Wait(500)
        end

        local ped = CreatePed(4, v.ped, v.coords, v.heading, false, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedDiesWhenInjured(ped, false)
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)

        exports['qb-target']:AddCircleZone(v.label, v.coords, 1.0, {
            name = v.label,
            debugPoly = false,
        }, {
            options = {
                {
                    type = "client",
                    event = "shop:checkAccess",
                    icon = "fas fa-store",
                    label = v.label
                },
                {
                    type = "client",
                    event = "shop:tipMenu",
                    icon = "fas fa-hand-holding-usd",
                    label = "Bahşiş Bırak"
                }
            },
            distance = 2.0
        })
    end
end)

RegisterNetEvent("shop:checkAccess", function()
    local playerPed = PlayerPedId()
    
    QBCore.Functions.Progressbar("checking_access", "Kart Kontrol Ediliyor...", 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() 
        if Config.UseItemForNPCEntrance then

            QBCore.Functions.TriggerCallback('shop:hasIllegalCard', function(hasCard)
                if hasCard then
                    TriggerEvent("shop:openMenu")
                else
                    QBCore.Functions.Notify("Geçersiz kart! Menüye erişim sağlanamadı.", "error")
                end
            end)
        else
            TriggerEvent("shop:openMenu")
        end
    end, function() 
        QBCore.Functions.Notify("İşlem iptal edildi.", "error")
    end)
end)

RegisterNetEvent("shop:tipMenu", function()
    local dialog = exports['qb-input']:ShowInput({
        header = "Bahşiş Bırak",
        submitText = "Bırak",
        inputs = {
            { type = 'number', isRequired = true, name = 'amount', text = 'Bahşiş Miktarı' }
        }
    })

    if dialog then
        local amount = tonumber(dialog.amount)

        if amount and amount > 0 then
            TriggerServerEvent("shop:giveTip", amount)
        else
            QBCore.Functions.Notify("Geçersiz bahşiş miktarı!", "error")
        end
    end
end)

RegisterNetEvent("shop:openMenu", function()
    local shop = Config.Peds[1] 
    local menuItems = {
        {
            header = shop.label .. " Menüsü",
            isMenuHeader = true,
        },
        {
            header = "Gıda Ürünleri",
            isMenuHeader = true,
        }
    }

    for _, item in pairs(shop.items) do
        local menuItem = {
            header = item.label,
            txt = string.format("%s - $%d", item.description, item.price),
            params = {
                event = "shop:selectItem",
                args = {
                    itemName = item.itemName,
                    price = item.price,
                    category = "food"
                }
            }
        }
        table.insert(menuItems, menuItem)
    end

    table.insert(menuItems, {header = "Silah ve Eşyalar", isMenuHeader = true})

    for _, weapon in pairs(shop.weapons) do
        local menuItem = {
            header = weapon.label,
            txt = string.format("%s - $%d", weapon.description, weapon.price),
            params = {
                event = "shop:selectItem",
                args = {
                    itemName = weapon.itemName,
                    price = weapon.price,
                    category = "weapons"
                }
            }
        }
        table.insert(menuItems, menuItem)
    end

    exports['qb-menu']:openMenu(menuItems)
end)

RegisterNetEvent("shop:selectItem", function(data)
    local dialog = exports['qb-input']:ShowInput({
        header = "Pazarlık Yap",
        submitText = "Satın Al",
        inputs = {
            { type = 'number', isRequired = true, name = 'quantity', text = 'Adet' },
            { type = 'number', isRequired = true, name = 'price', text = 'Pazarlık Fiyatı' }
        }
    })

    if dialog then
        local quantity = tonumber(dialog.quantity)
        local offeredPrice = tonumber(dialog.price)

        if quantity and quantity > 0 and offeredPrice and offeredPrice > 0 then

            local difficulty = Config.BargainDifficulty
            local originalPrice = data.price
            local finalPrice = originalPrice

            local chance = math.random()
            if offeredPrice >= originalPrice * (1 + difficulty) then
                finalPrice = offeredPrice
            end

            QBCore.Functions.TriggerCallback('shop:processBargain', function(success)
                if success then
                    TriggerServerEvent("shop:processPurchase", data.itemName, quantity, finalPrice)
                else
                    QBCore.Functions.Notify("Pazarlık başarısız oldu! Daha yüksek bir fiyat önerin.", "error")
                end
            end, originalPrice, offeredPrice)
        else
            QBCore.Functions.Notify("Geçersiz miktar veya fiyat!", "error")
        end
    end
end)
