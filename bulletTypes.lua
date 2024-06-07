local bulletTypes = {}

bulletTypes.basic = {}

bulletTypes.aoe = {
    color = { 0, 0.3, 1 },
}

function bulletTypes.aoe:update(dt)
    self.x = self.x + self.speedX * dt
    self.y = self.y + self.speedY * dt
    if self.x < 0 or self.y < 0 or self.x > 800 or self.y > 600 then
        self.kill = true
    end
    for i = #World.enemyHandler.Enemies, 1, -1 do
        local enemy = World.enemyHandler.Enemies[i]
        if self:isColidingCircle(enemy) then
            local explosion = { x = self.x, y = self.y, radius = 150 }
            explosion.draw = function(self)
                love.graphics.setColor(1, 0.1, 0.2, 0.5)
                love.graphics.circle("fill", self.x, self.y, self.radius)
            end
            World.timerHandler:new(0.25, function()
                explosion.kill = true
            end, false)
            World.graphicHandler:new(explosion)

            for j = #World.enemyHandler.Enemies, 1, -1 do
                local enemy = World.enemyHandler.Enemies[j]
                if self.isColidingCircle(explosion, enemy) then
                    enemy.hp = enemy.hp - self.damage
                    self.kill = true
                end
            end
        end
    end
end

bulletTypes.slow = {
    color = { 1, 1, 1 },
}

return bulletTypes
