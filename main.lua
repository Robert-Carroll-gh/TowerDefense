-- difficulty testing options
local HORDE_SIZE = 10
local SPAWN_RATE = 2
local ENEMY_HP = 20

-- load modules
local Bullets = require "bullets"
local Timers = require "timers"
local Utils = require "utils"
local Towers = require "towers"
local Enemies = require "enemies"
local map = require "map1"

-- declare globals

World = { bulletHandler = Bullets, timerHandler = Timers, enemyHandler = Enemies, map = map }

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

-- Begin game code
love.load = function()
    map.spawnEnemies(HORDE_SIZE, SPAWN_RATE, ENEMY_HP)
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

love.mousepressed = function(x, y, button, istouch, presses)
    if button == 1 then
        Towers:new(x, y)
    end
end

love.keypressed = function(key, scancode, isrepeat)
    if Utils.showDebug then
        print "Key Press:"
        print("    key:", key)
        print("    scancode:", scancode)
        print("    isrepeat:", isrepeat)
    end

    if key == "space" then
        map.spawnEnemies(HORDE_SIZE, SPAWN_RATE, ENEMY_HP)
    elseif key == "f3" then
        Utils:toggle()
    elseif key == "escape" then
        love.event.push "quit"
    end
end
