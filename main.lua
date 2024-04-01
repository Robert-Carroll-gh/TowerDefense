-- load modules
local Bullets = require "bullets"
local Timers = require "timers"
local Utils = require "utils"
local Towers = require "towers"
local Enemies = require "mob1"
require "map1"

-- declare globals
function ID(object)
    MaxID = MaxID or 0
    if object.id then
        return object.id
    end
    object.destroy = false
    object.id = MaxID + 1
    MaxID = object.id
    return object.id
end

local enemy
local tower
love.load = function()
    love.window.setVSync(0)
    tower = Towers:new(450, 50, Bullets, Timers)
    enemy = Enemies:new(150, 200)
    tower:target(enemy)
end

love.draw = function()
    map.draw()
    Enemies:draw()
    Towers:draw()
    Bullets:draw()

    Utils:drawDebug()
end

love.update = function(dt)
    Enemies:update(dt)
    Towers:update(dt)
    Timers:update(dt)
    Bullets:update(dt)
end

love.keypressed = function(key, scancode, isrepeat)
    if Utils.showDebug then
        print "Key Press:"
        print("    key:", key)
        print("    scancode:", scancode)
        print("    isrepeat:", isrepeat)
    end

    if key == "j" then
        enemy.hp = enemy.hp - 1
    elseif key == "f3" then
        Utils:toggle()
    elseif key == "escape" then
        love.event.push "quit"
    end
end
