Bullet = require("bullet")
require("tower")
require("mob1")


love.load = function()
    tower = Tower:new(50,50)
    bullet = Bullet:new(500,200,tower.x,tower.y)
end

love.draw = function()
    bullet:draw()
    tower:draw()
	enemy.draw()
end

love.update = function(dt)
    bullet:update(dt)
end
