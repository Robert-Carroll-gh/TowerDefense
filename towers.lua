--- # Provides an object to create and handle Towers 
---@see Tower

---@class TowerHandler
---@field Towers Tower[]
local TowerHandler = {Towers = {}}

---@class Tower
local Tower = {
    x = 0,
    y = 0,
    width = 50,
    height = 50,
    color = {0.3,0.3,0.3},
    fireRate = 1, -- time between shots
    damage = 1, -- damage per shot  
}

---not a TowerHandler constructor 
--- instead, constructs Tower and adds it to the handler's list
---@param x number 
---@param y number 
---@param bulletHandler BulletHandler?
---@param timerHandler TimerHandler?
---@return Tower
function TowerHandler:new(x, y, bulletHandler, timerHandler)
    local tower = Tower:new(x, y, bulletHandler, timerHandler)
    table.insert(self.Towers, tower)
    return tower
end

function TowerHandler:update(dt)
    for _, tower in ipairs(self.Towers) do
        tower:update(dt)
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
---@param bulletHandler BulletHandler?
---@param timerHandler TimerHandler?
---@return Tower
function Tower:new(x,y, bulletHandler, timerHandler)
    if bulletHandler then
        self.bulletList = bulletHandler
    end
    if timerHandler then
        self.timerHandler = timerHandler
    end
    local t = {}
    self.__index = self
    setmetatable(t, self)
    t.x, t.y = x, y

    return t
end

---sets a target and begins firing
---@param target table # a table with an x value and a y value
---@return Timer
function Tower:target(target)
    self.target = target
    local timer = self.timerHandler:new(self.fireRate, function() self:shoot(self.target.x, self.target.y) end)
    self.shotTimer = timer
    return timer
end

function Tower:draw()
    love.graphics.setColor(self.color)
    love.graphics.rectangle("fill",
        self.x - self.width / 2,
        self.y - self.height / 2,
        self.width, self.height)
end

function Tower:shoot(x, y)
    self.bulletList:new(self.x, self.y, x, y)
end

function Tower:update(dt)
    if not self.target then
        self.shotTimer:kill()
    end
end

return TowerHandler
