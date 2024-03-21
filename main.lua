Bullets = require("bullets")
Timers = require("timers")
Utils = require("utils")
Towers = require("towers")
require("mob1")
require("map1")

love.load = function()
    Tower = Towers:new(450,50, Bullets, Timers)
    Tower:target(enemy)
end

love.draw = function()
    map.draw()
	enemy.draw()
    Towers:draw()
    Bullets:draw()

    Utils.drawDebug()
end

love.update = function(dt)
    Towers:update(dt)
    Timers:update(dt)
    Bullets:update(dt)
end

love.keypressed = function(key, scancode, isrepeat)
	if Utils.showDebug then
        print("Key Press:")
        print("    key:", key)
        print("    scancode:", scancode)
        print("    isrepeat:", isrepeat)
	end

	if key == "j" then
		enemy.hp = enemy.hp - 1
	elseif key == "f3" then
        Utils.showDebug = (not Utils.showDebug)
	elseif key == "escape" then
        love.event.push("quit")
	end
end
