Projectiles = require("projectiles")
Timers = require("timers")
Utils = require("utils")
require("tower")
require("mob1")

love.load = function()
    ShowDebug = false

    tower = Tower:new(450,50)
    tower.target = enemy
end

love.draw = function()
    tower:draw()
	enemy.draw()
    Projectiles:draw()

    if ShowDebug then
        Utils.drawDebug()
    end
end

love.update = function(dt)
    Timers:update(dt)
    tower:update(dt)
    Projectiles:update(dt)
end

love.keypressed = function(key, scancode, isrepeat)
	if ShowDebug then
        print("Key Press:")
        print("    key:", key)
        print("    scancode:", scancode)
        print("    isrepeat:", isrepeat)
	end

	if key == "j" then
		enemy.hp = enemy.hp - 1
	elseif key == "f3" then
        ShowDebug = (not ShowDebug)
	end
end
