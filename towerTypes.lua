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
    upgradesTo = "fairy_cloud",
    color = { 1, 0, 1 },
    fireRate = 5,
    manaGeneration = 25,

    generateMana = function(self)
        local newMana = World.mana + self.manaGeneration
        if newMana <= World.manaCap then
            World.mana = newMana
        else
            World.mana = World.manaCap
        end
        World.graphicHandler:flashCircle(self.x, self.y, 75, Utils.setAlpha(ManaColor, 0.5))
    end,

    new = function(self, x, y)
        local t = World.towerHandler.Tower.new(self, x, y)
        t.shotTimer = World.timerHandler:new(self.fireRate, function()
            t:generateMana()
        end, true)

        self.__index = self
        setmetatable(t, self)

        return t
    end,

    update = function(self, dt)
        if self.hp <= 0 then
            self.kill = true
        end
        if self.kill == true then
            self.shotTimer.kill = true
        end
    end,
}

towerTypes.fairy_cloud = {
    cost = 50,
    upgradesFrom = "fae_puff",
    upgradesTo = "sacred_haven",
    color = { 1, 0, 1 },
    width = 55,
    height = 55,
    fireRate = 5,
    manaGeneration = 50,

    generateMana = function(self)
        local newMana = World.mana + self.manaGeneration
        if newMana <= World.manaCap then
            World.mana = newMana
        else
            World.mana = World.manaCap
        end
        World.graphicHandler:flashCircle(self.x, self.y, 75, Utils.setAlpha(ManaColor, 0.5))
    end,

    new = function(self, x, y)
        local t = World.towerHandler.Tower.new(self, x, y)
        t.shotTimer = World.timerHandler:new(self.fireRate, function()
            t:generateMana()
        end, true)

        self.__index = self
        setmetatable(t, self)

        return t
    end,

    update = function(self, dt)
        if self.hp <= 0 then
            self.kill = true
        end
        if self.kill == true then
            self.shotTimer.kill = true
        end
    end,
}

towerTypes.sacred_haven = {
    cost = 1000,
    upgradesFrom = "fairy_cloud",
    upgradesTo = "none",
    color = { 1, 0, 1 },
    width = 60,
    height = 60,
    manaGeneration = 150,
    fireRate = 1.5,

    generateMana = function(self)
        local newMana = World.mana + self.manaGeneration
        if newMana <= World.manaCap then
            World.mana = newMana
        else
            World.mana = World.manaCap
        end
        World.graphicHandler:flashCircle(self.x, self.y, 75, Utils.setAlpha(ManaColor, 0.5))
    end,

    new = function(self, x, y)
        World.manaCap = World.manaCap + 1000

        local t = World.towerHandler.Tower.new(self, x, y)
        t.shotTimer = World.timerHandler:new(self.fireRate, function()
            t:generateMana()
        end, true)

        self.__index = self
        setmetatable(t, self)

        return t
    end,

    update = function(self, dt)
        if self.hp <= 0 then
            self.kill = true
        end
        if self.kill == true then
            self.shotTimer.kill = true
        end
    end,

    --[[ new = function(self, x, y)
        towerTypes.fae_puff.new(self, x, y)
        World.manaCap = World.manaCap + 1000
    end, ]]
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
