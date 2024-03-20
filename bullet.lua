require("utils")

local Bullet = {
    x = 0,
    y = 0,
    speed = 600, -- pixels / second 
    speedX = 0,
    speedY = 0,

    radius = 5,
    color = {1, 0, 0}
}

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
    self.speedX, self.speedY = normalize(vX, vY, self.speed)
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

return Bullet
