Bullet = require("bullet")
Projectiles = require("projectiles")
require("tower")
require("mob1")
require("utils")

love.load = function()
    tower = Tower:new(50,50)
    tower.target = enemy
end

love.draw = function()
    tower:draw()
	enemy.draw()
    Projectiles:draw()

    drawMoreInfo()
end

love.update = function(dt)
    tower:update(dt)
    Projectiles:update(dt)
end
