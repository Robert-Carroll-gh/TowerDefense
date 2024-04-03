--- # Provides an object to create and handle Towers
---@see Tower

---@class TowerHandler
---@field Towers Tower[]
local TowerHandler = { Towers = {} }

---@class Tower
local Tower = {
    x = 0,
    y = 0,
    width = 50,
    height = 50,
    color = { 0.3, 0.3, 0.3 },
    fireRate = 1, -- seconds between shots
    -- damage = 1, -- damage per shot
    hp = 100,
}

---not a TowerHandler constructor
--- instead, constructs Tower and adds it to the handler's list
---@param x number
---@param y number
---@return Tower
function TowerHandler:new(x, y)
    local tower = Tower:new(x, y)
    table.insert(self.Towers, tower)
    return tower
end

function TowerHandler:update(dt)
    for i = #self.Towers, 1, -1 do
        local tower = self.Towers[i]
        if tower.kill then
            table.remove(self.Towers, i)
        else
            tower:update(dt)
        end
    end
end

function TowerHandler:draw()
    for _, tower in ipairs(self.Towers) do
        tower:draw()
    end
end

---Tower constructor
---@param x number
---@param y number
---@return Tower
function Tower:new(x, y)
    local t = {}
    self.__index = self
    setmetatable(t, self)
    t.x, t.y = x, y

    return t
end

---sets a target and begins firing
---@param target table # a table with an x value and a y value
---@return Timer
function Tower:hunt(target)
    self.target = target
    local timer = World.timerHandler:new(self.fireRate, function()
        self:shoot(self.target.x, self.target.y)
        if self.target.kill then
            self.target = nil
        end
    end)
    self.shotTimer = timer
    return timer
end

function Tower:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill", self.x - self.width / 2, self.y - self.height / 2, self.width, self.height)
end

function Tower:shoot(x, y)
    World.bulletHandler:new(self.x, self.y, x, y)
end

function Tower:update(dt)
    if self.hp <= 0 then
        self.kill = true
    end
    if self.target == nil then
        if self.shotTimer then
            self.shotTimer.kill = true
        end
        local enemies = World.enemyHandler.Enemies
        local nextTarget = enemies[1]
        if nextTarget then
            self:hunt(nextTarget)
        end
    end
end

return TowerHandler
