Projectiles = require("projectiles")
Timers = require("timers")
require("tower")
require("mob1")
require("utils")

love.load = function()
    tower = Tower:new(450,50)
    tower.target = enemy
end

love.draw = function()
    tower:draw()
	enemy.draw()
    Projectiles:draw()

    drawMoreInfo()
end

love.update = function(dt)
    Timers:update(dt)
    tower:update(dt)
    Projectiles:update(dt)
end
