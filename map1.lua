-- Define the map layout
local map = {
    { 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
    { 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 0 },
    { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0 },
    { 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0 },
    { 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1 },
    { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 },
}

function map.draw()
    -- Map Matrix
    love.graphics.setColor(0, 0.5, 0)
    for y = 1, #map do
        for x = 1, #map[y] do
            if map[y][x] == 1 then
                -- Draw path tile
                love.graphics.rectangle("line", (x - 1) * 50, (y - 1) * 50, 50, 50)
            else
                -- Draw empty space
                love.graphics.rectangle("fill", (x - 1) * 50, (y - 1) * 50, 50, 50)
            end
        end
    end
    -- Start
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("", 110, 15)
    love.graphics.print("End", 663, 575)
end

map.enemyPath = {
    { 125, -40 },
    { 125, 75 },
    { 475, 75 },
    { 475, 225 },
    { 325, 225 },
    { 325, 325 },
    { 225, 325 },
    { 225, 475 },
    { 525, 475 },
    { 525, 325 },
    { 675, 325 },
    { 675, 640 },
}

map.spawnEnemies = function(num, wait, hp)
    World.timerHandler:new(wait, function()
        World.enemyHandler:new(map.enemyPath[1][1], map.enemyPath[1][2], hp)
    end, num)
end

return map

