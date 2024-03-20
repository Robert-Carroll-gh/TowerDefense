local Projectiles = {}
Projectiles[1] = {}

function Projectiles:update(dt)
    for k, bullet in pairs(self[1]) do
        bullet:update(dt)
        if bullet.x < 0 or bullet.y < 0
        or bullet.x > 800 or bullet.y > 600 then
            table.remove(self[1], k)
        end

        if bullet:isColidingCircle(enemy) then
            enemy.hp = enemy.hp - 1
            table.remove(self[1], k)
        end
    end
end

function Projectiles:draw()
    for _, bullet in pairs(self[1]) do
        bullet:draw()
    end
end

function Projectiles:new()
    local p = {}
    self.__index = self
    setmetatable(p, self)
end

return Projectiles
