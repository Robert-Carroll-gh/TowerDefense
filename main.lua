require("mob1")
print("hello world")

x = 45

print(x)

love.load = function() end

love.draw = function()
	love.graphics.print("hello world", 300, 150)
	love.graphics.rectangle("fill", 10, 10, 50, 100)
	enemy.draw()
end
