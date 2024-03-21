local utils = require("utils")

---@class BulletHandler
---@field Bullets Bullet[]
local BulletHandler = {Bullets = {}}

---@class Bullet
local Bullet = {
    x = 0,
    y = 0,
    speed = 600, -- pixels / second 
    speedX = 0,
    speedY = 0,

    radius = 5,
    color = {1, 0, 0}
}

function BulletHandler:update(dt)
    for i, bullet in ipairs(self.Bullets) do
        bullet:update(dt)
        if bullet.x < 0 or bullet.y < 0
        or bullet.x > 800 or bullet.y > 600 then
            table.remove(self.Bullets, i)
        end

        if enemy and bullet:isColidingCircle(enemy) then --TODO: make this loop through all enemies once that is possible
            enemy.hp = enemy.hp - 1
            table.remove(self.Bullets, i)
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
---@param x number 
---@param y number 
---@param targetX number 
---@param targetY number 
---@return Bullet
---@overload fun(self: BulletHandler, x: number, y: number, target: table)
function BulletHandler:new(x, y, targetX, targetY) -- can also be called as (x, y, target)
    local bullet = Bullet:new(x, y, targetX, targetY)
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
    self.__index = self
    setmetatable(b, self)

    b.x, b.y = x, y
    if type(targetX) == "table" then
        local target = targetX
        targetX, targetY = target.x, target.y
    end
    b:target(targetX,targetY)

    return b
end

function Bullet:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
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
    local minDistanceSquared = self.radius^2 + circleObject.radius^2
    local distanceSquared = distanceX^2 + distanceY^2

    if distanceSquared <= minDistanceSquared then
        return true
    end
    return false
end

return BulletHandler
