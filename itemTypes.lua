local itemTypes = {}
local TowerUpgrades = require "towerUpgrades"

itemTypes.Saphire = {
    effect = TowerUpgrades.fireRate(1.1),
    usage = "towerUpgrade",
}

return itemTypes
