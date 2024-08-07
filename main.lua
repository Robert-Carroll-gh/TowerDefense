math.randomseed(os.time())

-- difficulty testing options
local HORDE_SIZE = 5
local SPAWN_RATE = 3
local ENEMY_HP = 5
local STARTING_MANA = 500
local STARTING_MANA_CAP = 1000

-- load modules
local Bullets = require "bullets"
local Timers = require "timers"
local Towers = require "towers"
local Items = require "items"
local Enemies = require "enemies"
local map = require "map1"
local gui = require "gui"
local Graphics = require "graphicEffects"

-- declare globals
Utils = require "utils"
ManaColor = { 0, 1, 1 }

World = {
    mana = STARTING_MANA,
    manaCap = STARTING_MANA_CAP,
    graphicHandler = Graphics,
    bulletHandler = Bullets,
    timerHandler = Timers,
    enemyHandler = Enemies,
    map = map,
    gui = gui,
    towerHandler = Towers,
    itemHandler = Items,
}

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

    gui:loadGameMenu()
end

love.draw = function()
    map.draw()
    Graphics:draw()
    Enemies:draw()
    Towers:draw()
    Bullets:draw()
    Items:draw()
    gui:draw()

    Utils:drawDebug()
end

love.update = function(dt)
    Graphics:update(dt)
    Enemies:update(dt)
    Towers:update(dt)
    Timers:update(dt)
    Bullets:update(dt)
    Items:update(dt)
    gui:update(dt)
end

love.mousepressed = function(x, y, mouseButton, istouch, presses)
    if gui:processClick(x, y, mouseButton) then
        return true
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
    elseif key == "m" then
        -- cheat
        World.mana = World.manaCap
    elseif key == "escape" then
        love.event.push "quit"
    elseif key == "r" then
        --reset

        Bullets = require "bullets"
        Timers = require "timers"
        Towers = require "towers"
        Items = require "items"
        Enemies = require "enemies"
        map = require "map1"
        gui = require "gui"
        Graphics = require "graphicEffects"

        Utils = require "utils"
        ManaColor = { 0, 1, 1 }

        World = {
            mana = STARTING_MANA,
            manaCap = STARTING_MANA_CAP,
            graphicHandler = Graphics,
            bulletHandler = Bullets,
            timerHandler = Timers,
            enemyHandler = Enemies,
            map = map,
            gui = gui,
            towerHandler = Towers,
            itemHandler = Items,
        }
    end
end
