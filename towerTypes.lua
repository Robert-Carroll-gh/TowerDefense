local towerTypes = {}

towerTypes.basic = {
    cost = 10,
}

towerTypes.mystic = {
    upgradesFrom = nil,
    upgradesTo = "arcane",
    cost = 50,
    color = { 0.5, 1, 0 },
    bulletType = "star",
}

towerTypes.arcane = {
    upgradesFrom = "mystic",
    upgradesTo = "crescent_moon",
    cost = 50,
    color = { 0.6, 1, 0 },
    bulletType = "star",
    shotCounter = 0,
}
function towerTypes.arcane:shoot(x, y)
    World.bulletHandler:new(self.bulletType or "basic", self.x, self.y, x, y)
    self.shotCounter = self.shotCounter + 1
    if self.shotCounter == 2 then
        self.bulletType = "aoe"
    else
        self.bulletType = "star"
    end
    if self.shotCounter == 3 then
        self.shotCounter = 0
    end
end

towerTypes.crescent_moon = {
    upgradesFrom = "arcane",
    upgradesTo = "none",
    cost = 150,
    color = { 0.6, 1, 0 },
    bulletType = "aoe",
    fireRate = 0.75,
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

towerTypes.elf_lantern = {
    upgradesFrom = nil,
    upgradesTo = "elf_crystal",
    cost = 100,
    color = { 1, 1, 1 },
    slowValue = 0.25,
    -- bulletType = "slow",
}
function towerTypes.elf_lantern:update(dt)
    if self.hp <= 0 then
        self.kill = true
        return true
    end
    local enemies = World.enemyHandler.Enemies
    local notSlowed = function(enemy)
        return enemy.slow == nil or enemy.slow == 0
    end
    if self.target == nil then
        local nextTarget = Utils.closestObject(self.x, self.y, enemies, notSlowed)
        if nextTarget then
            self:hunt(nextTarget)
        end
    elseif self.target.kill then
        self.target = nil
    end
end

function towerTypes.elf_lantern:hunt(target)
    self.target = target
    target.slow = self.slowValue
    World.graphicHandler:lineLink(self, target, 4, self.color)
end

function towerTypes.elf_lantern:cleanup()
    if self.target ~= nil then
        self.target.slow = nil
    end
end

towerTypes.elf_crystal = {
    upgradesFrom = "elf_lantern",
    upgradesTo = "elven_night_ward",
    cost = 75,
    color = { 1, 1, 1 },
    slowValue = 0.25,
}

function towerTypes.elf_crystal:update(dt)
    if self.hp <= 0 then
        self.kill = true
        return true
    end
    local enemies = World.enemyHandler.Enemies
    local notSlowed = function(enemy)
        return enemy.slow == nil or enemy.slow == 0
    end
    if self.target1 == nil then
        local nextTarget = Utils.closestObject(self.x, self.y, enemies, notSlowed)
        if nextTarget then
            self:hunt(nextTarget, 1)
        end
    elseif self.target1.kill then
        self.target1 = nil
    end
    if self.target2 == nil then
        local nextTarget = Utils.closestObject(self.x, self.y, enemies, notSlowed)
        if nextTarget then
            self:hunt(nextTarget, 2)
        end
    elseif self.target2.kill then
        self.target2 = nil
    end
end

function towerTypes.elf_crystal:hunt(target, targetSlot)
    if targetSlot == 1 then
        self.target1 = target
    elseif targetSlot == 2 then
        self.target2 = target
    end
    target.slow = self.slowValue
    World.graphicHandler:lineLink(self, target, 4, self.color)
end

function towerTypes.elf_crystal:cleanup()
    if self.target1 ~= nil then
        self.target1.slow = nil
    end
    if self.target2 ~= nil then
        self.target2.slow = nil
    end
end

towerTypes.elven_night_ward = {
    cost = 200,
    upgradesFrom = "elf_crystal",
    upgradesTo = "none",
    color = { 1, 1, 1 },
    fireRate = 5,
    freezeDuration = 1,
}

function towerTypes.elven_night_ward:freeze()
    World.graphicHandler:flashCircle(self.x, self.y, 75, { 1, 1, 1, 0.5 })

    for i, enemy in ipairs(World.enemyHandler.Enemies) do
        if enemy.slow ~= nil and enemy.slow ~= 0 then
            enemy.waitTime = enemy.waitTime + self.freezeDuration
        end
    end
end

function towerTypes.elven_night_ward:new(x, y)
    local t = World.towerHandler.Tower.new(self, x, y)
    t.shotTimer = World.timerHandler:new(self.fireRate, function()
        t:freeze()
    end, true)

    self.__index = self
    setmetatable(t, self)

    return t
end
function towerTypes.elven_night_ward:update(dt)
    if self.hp <= 0 then
        self.kill = true
    end
    if self.kill == true then
        self.shotTimer.kill = true
    end
end

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
