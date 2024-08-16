Config = {}

Config.Peds = {
    {
        ped = "a_m_y_business_01", 
        coords = vector3(-45.00, -1750.00, 29.00), 
        heading = 90.0, 
        label = "Küçük Dükkan", 
        items = {
            {
                label = "Ekmek",
                description = "Taze ekmek",
                itemName = "bread",
                price = 10,
                event = "shop:buyItem"
            },
            {
                label = "Süt",
                description = "Taze süt",
                itemName = "milk",
                price = 15,
                event = "shop:buyItem"
            }
        },
        weapons = {
            {
                label = "Tabanca",
                description = "Bir tabanca",
                itemName = "weapon_pistol",
                price = 500,
                event = "shop:buyItem"
            },
            {
                label = "Tabanca Mermisi",
                description = "Bir tabanca mermisi",
                itemName = "pistol_ammo",
                price = 50,
                event = "shop:buyItem"
            },
            {
                label = "Telefon",
                description = "Bir telefon",
                itemName = "phone",
                price = 1000,
                event = "shop:buyItem"
            }
        }
    }
}

Config.UseItemForNPCEntrance = true
Config.IllegalCard = "illegal_kart" -- Giriş Kartının itemi kafanıza göre ayarlıyın

-- Pazarlık zorlukları (0-1 arası)
Config.BargainDifficulty = 0.5
