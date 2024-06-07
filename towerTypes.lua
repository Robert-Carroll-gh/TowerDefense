local towerTypes = {}

towerTypes.basic = {
    cost = 10,
}

towerTypes.aoe = {
    cost = 50,
    color = { 0, 0.3, 1 },
    bulletType = "aoe",
    fireRate = 3,
}

towerTypes.mana = {
    color = { 1, 0, 1 },
}

towerTypes.slow = {
    color = { 1, 1, 1 },
    bulletType = "slow",
}

return towerTypes
