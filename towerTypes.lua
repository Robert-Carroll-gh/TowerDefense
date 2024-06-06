local towerTypes = {}

towerTypes.basic = {}

towerTypes.aoe = {
    color = { 0, 0.3, 1 },
    bulletType = "aoe",
}

towerTypes.mana = {
    color = { 1, 0, 1 },
}

towerTypes.slow = {
    color = { 1, 1, 1 },
    bulletType = "slow",
}

return towerTypes
