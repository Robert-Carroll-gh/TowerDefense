local smiley = love.graphics.newImage("images/mob1.png")

---@class EnemyHandler
---@field Enemies Enemy[]
local EnemyHandler = { Enemies = {}, }

---@class Enemy
local Enemy = {
    x = 0,
    y = 0,
    radius = smiley:getHeight() / 2,
    hp = 10,

    olddraw = function(self)
        love.graphics.setColor(1, 1, 1)

        love.graphics.print(self.hp, self.x, self.y + 50)

        love.graphics.circle("fill", self.x, self.y, self.radius)
    end,

    draw = function(self)
        love.graphics.draw(smiley, self.x - self.radius, self.y - self.radius)
        love.graphics.print(self.hp, self.x, self.y + 50)
    end
}

function Enemy:update(dt)
    return dt
end

function EnemyHandler:update(dt)
    for i, enemy in ipairs(self.Enemies) do
        enemy:update(dt)
        if enemy.hp <= 0 then
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
function EnemyHandler:new(x, y)
    local enemy = Enemy:new(x, y)
    table.insert(self.Enemies, enemy)
    return enemy
end

---Enemy constructor
---@param x number
---@param y number
---@return Enemy
function Enemy:new(x, y)
    local e = {}
    self.__index = self
    setmetatable(e, self)

    e.x, e.y = x, y

    return e
end

return EnemyHandler
