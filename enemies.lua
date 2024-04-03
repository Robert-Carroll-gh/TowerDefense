local utils = require "utils"

local smiley = love.graphics.newImage "images/mob1.png"

---@class EnemyHandler
---@field Enemies Enemy[]
local EnemyHandler = { Enemies = {} }

---@class Enemy
local Enemy = {
    x = 0,
    y = 0,
    radius = smiley:getHeight() / 2,
    hp = 25,
    speed = 100,
    speedX = 0,
    speedY = 0,
    pathNode = 1,

    olddraw = function(self)
        love.graphics.setColor(1, 1, 1)

        love.graphics.print(self.hp, self.x, self.y + 50)

        love.graphics.circle("fill", self.x, self.y, self.radius)
    end,

    draw = function(self)
        love.graphics.draw(smiley, self.x - self.radius, self.y - self.radius)
        love.graphics.print(self.hp, self.x, self.y + 50)
    end,
}

function Enemy:update(dt)
    if self.hp <= 0 then
        self.kill = true
    end

    local pathNode = World.map.enemyPath[self.pathNode]

    local vecToX, vecToY = utils.vecTo(self.x, self.y, pathNode[1], pathNode[2])
    self.speedX, self.speedY = utils.normalize(vecToX, vecToY, self.speed * dt)
    self.x = self.x + self.speedX
    self.y = self.y + self.speedY

    if utils.lengthSquared(vecToX, vecToY) <= 16 then
        self.pathNode = self.pathNode + 1
        if self.pathNode > #World.map.enemyPath then
            self.kill = true
            print "enemy escaped"
            return
        end
    end
end

function EnemyHandler:update(dt)
    for i, enemy in ipairs(self.Enemies) do
        enemy:update(dt)
        if enemy.kill then
            table.remove(self.Enemies, i)
        end
    end
end

function EnemyHandler:draw()
    for _, enemy in pairs(self.Enemies) do
        enemy:draw()
    end
end

--- not a constructor for EnemyHandler
--- constructs a Enemy, and adds it to the handler's list
---@param x number
---@param y number
---@return Enemy
function EnemyHandler:new(x, y, hp)
    local enemy = Enemy:new(x, y, hp)
    table.insert(self.Enemies, enemy)
    return enemy
end

---Enemy constructor
---@param x number
---@param y number
---@return Enemy
function Enemy:new(x, y, hp)
    local e = {}
    self.__index = self
    setmetatable(e, self)

    e.x, e.y = x, y
    e.hp = hp

    return e
end

return EnemyHandler
