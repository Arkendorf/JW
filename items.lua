local items = {}
items[3] = {name = "Repair", disc = "Replenishes your plane's HP by one point", price = 4}
items[4] = {name = "Ammo", disc = "Useful when firing weapons", price = .2}
items[5] = {name = "Money", disc = "Currency for shops", price = 0}

items[1] = {}
items[1][1] = {name = "Automatic Gun", disc = "Standard issue weapon that rapidly fires bullets", price = 2, img = 1}
items[1][2] = {name = "Bomb Cannon", disc = "A powerful cannon that fires short range explosive projectiles", price = 6, img = 2}
items[1][3] = {name = "Piercing Hwacha", disc = "An accurate weapon that fires piercing shots", price = 4, img = 3}

items[2] = {}
items[2][1] = {name = "Max HP", disc = "Increase your plane's max HP by 1", price = 6, stat = "hp_max", num = 1}
items[2][2] = {name = "Max Ammo", disc = "Increase your plane's max ammo by 6", price = 5, stat = "ammo_max", num = 6}
items[2][3] = {name = "Speed", disc = "Increase your plane's speed", price = 4, stat = "speed", num = .2}
items[2][4] = {name = "Recover Time", disc = "Increase invulnerability time after taking damage", price = 4, stat = "inv_time", num = .4}

return items
