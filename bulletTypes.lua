local bulletTypes = {}

bulletTypes.basic = {}

bulletTypes.star = {
    color = { 0.5, 1, 0 },
    image = love.graphics.newImage "images/star.png",
}
function bulletTypes.star:draw()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.image, self.x, self.y)
end

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
            local explosion = World.graphicHandler:flashCircle(self.x, self.y, 150, { 1, 0, 0, 0.3 })

            for j = #World.enemyHandler.Enemies, 1, -1 do
                enemy = World.enemyHandler.Enemies[j]
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
