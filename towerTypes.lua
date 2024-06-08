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

towerTypes.fae_puff = {
    cost = 100,
    upgradesFrom = nil,
    upgradesTo = "fairyCloud",
    color = { 1, 0, 1 },
    fireRate = 5,
    manaGeneration = 25,

    generateMana = function(self)
        World.mana = World.mana + self.manaGeneration
        World.graphicHandler:flashCircle(self.x, self.y, 75, Utils.setAlpha(ManaColor, 0.5))
    end,

    new = function(self, x, y)
        local t = World.towerHandler.Tower.new(self, x, y)
        t.update = function()
            if self.hp <= 0 then
                self.kill = true
            end
        end
        t.shotTimer = World.timerHandler:new(self.fireRate, function()
            t:generateMana()
        end, true)

        return t
    end,
}

towerTypes.fairyCloud = {
    cost = 20,
    upgradesFrom = "fae_puff",
    upgradesTo = "none",
    color = { 1, 0, 0.8 },
    width = 75,
    height = 75,
    manaGeneration = 50,
}

towerTypes.slow = {
    cost = 10000,
    color = { 1, 1, 1 },
    bulletType = "slow",
}

-- so I don't have to worry about declaring everything in the right order for one upgrade direction and go back seperately after for the other direction
for name, tower in pairs(towerTypes) do
    tower.__index = tower
    if tower.upgradesFrom ~= nil then
        local upgradesFrom = towerTypes[tower.upgradesFrom]
        if upgradesFrom == nil then
            error("Tower Type: " .. name .. "; invalid upgradesFrom: " .. tower.upgradesFrom)
        end
        tower.upgradesFrom = upgradesFrom
        tower.__index = tower.upgradesFrom
        setmetatable(tower, upgradesFrom)
    end

    if tower.upgradesTo ~= nil then
        local upgradesTo = towerTypes[tower.upgradesTo]
        if upgradesTo == nil and tower.upgradesTo ~= "none" then
            error("Tower Type: " .. name .. "; invalid upgradesTo: " .. tower.upgradesTo)
        end
        tower.upgradesTo = upgradesTo
    end
end

return towerTypes
