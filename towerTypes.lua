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
    cost = 100,
    color = { 1, 0, 1 },
    fireRate = 5,
    manaGeneration = 25,
    generateMana = function(self)
        World.mana = World.mana + self.manaGeneration
        World.graphicHandler:flashCircle(self.x, self.y, 75, Utils.setAlpha(ManaColor, 0.5))
    end,
}
function towerTypes.mana:new(x, y)
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
end

towerTypes.slow = {
    color = { 1, 1, 1 },
    bulletType = "slow",
}

return towerTypes
