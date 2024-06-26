local utils = require "utils"

---@class BulletHandler
---@field Bullets Bullet[]
local BulletHandler = { Bullets = {} }

---@class Bullet
local Bullet = {
    x = 0,
    y = 0,
    speed = 600, -- pixels / second
    speedX = 0,
    speedY = 0,
    damage = 1,

    radius = 5,
    color = { 1, 0, 0 },
}
Bullet.__index = Bullet

BulletHandler.types = require "bulletTypes"
for name, bullet in pairs(BulletHandler.types) do
    bullet.__index = Bullet
    setmetatable(bullet, Bullet)
end

function BulletHandler:update(dt)
    for i = #self.Bullets, 1, -1 do
        local bullet = self.Bullets[i]
        if bullet.kill then
            table.remove(self.Bullets, i)
        else
            bullet:update(dt)
        end
    end
end

function BulletHandler:draw()
    for _, bullet in pairs(self.Bullets) do
        bullet:draw()
    end
end

--- not a constructor for BulletHandler
--- constructs a Bullet, and adds it to the handler's list
---@param type string
---@param x number
---@param y number
---@param targetX number
---@param targetY number
---@return Bullet
---@overload fun(self: BulletHandler, type: string, x: number, y: number, target: table)
function BulletHandler:new(type, x, y, targetX, targetY) -- can also be called as (x, y, target)
    local bullet
    if BulletHandler.types[type] ~= nil then
        bullet = BulletHandler.types[type]:new(x, y, targetX, targetY)
    else
        bullet = Bullet:new(x, y, targetX, targetY)
    end
    table.insert(self.Bullets, bullet)
    return bullet
end

---Bullet constructor
---@param x number
---@param y number
---@param targetX number
---@param targetY number
---@return Bullet
---@overload fun(x: number, y: number, target: table)
function Bullet:new(x, y, targetX, targetY) -- can also be called as (x, y, target)
    local b = {}
    --ID(b)
    self.__index = self
    setmetatable(b, self)

    b.x, b.y = x, y
    if type(targetX) == "table" then
        local target = targetX
        targetX, targetY = target.x, target.y
    end
    b:target(targetX, targetY)

    return b
end

function Bullet:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
    if self.x < 0 or self.y < 0 or self.x > 800 or self.y > 600 then
        self.kill = true
    end
    for i = #World.enemyHandler.Enemies, 1, -1 do
        local enemy = World.enemyHandler.Enemies[i]
        if self:isColidingCircle(enemy) then
            enemy.hp = enemy.hp - self.damage
            self.kill = true
        end
    end
end

function Bullet:draw()
    love.graphics.setColor(self.color)
    love.graphics.circle("fill", self.x, self.y, self.radius)
end

function Bullet:target(targetX, targetY)
    local vX, vY = targetX - self.x, targetY - self.y
    self.speedX, self.speedY = utils.normalize(vX, vY, self.speed)
end

function Bullet:isColidingCircle(circleObject)
    local distanceX = self.x - circleObject.x
    local distanceY = self.y - circleObject.y
    local minDistanceSquared = (self.radius + circleObject.radius) ^ 2
    local distanceSquared = distanceX ^ 2 + distanceY ^ 2

    if distanceSquared <= minDistanceSquared then
        return true
    end
    return false
end

return BulletHandler
