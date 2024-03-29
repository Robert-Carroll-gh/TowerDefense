enemy = {
    x = 200,
    y = 150,
    radius = 20,
    hp = 3,



    draw = function()
        love.graphics.setColor(1, 1, 1)

        love.graphics.print(enemy.hp, enemy.x, enemy.y + 50)

        love.graphics.circle("fill", enemy.x, enemy.y, enemy.radius)
    end
}

enemy.update = function()
    local shouldDrawEnemy = true
    local enemyIsAlive = enemy.hp >= 1
    local shouldDrawEnemy = enemyIsAlive

    if shouldDrawEnemy == true then
        enemy.draw()
    end

    if enemy.hp == 0 then
        shouldDrawEnemy = false
    end
end
