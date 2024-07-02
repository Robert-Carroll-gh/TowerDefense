local itemTypes = {}
local TowerUpgrades = require "towerUpgrades"

itemTypes.Saphire = {
    typeName = "Saphire",
    effect = TowerUpgrades.fireRate(1.1),
    usage = "towerUpgrade",
}

return itemTypes
