

function drawMoreInfo()
    love.graphics.setColor(1,1,1)
    local mousePositionText = "   X:"..love.mouse.getX() .. " Y: " .. love.mouse.getY()
    love.graphics.print(mousePositionText, love.mouse.getX(), love.mouse.getY())

end


function normalize(x, y, newLength)
    local length = math.sqrt(x^2 + y^2)
    x = x / length
    y = y / length
    if newLength then
        x = x * newLength
        y = y * newLength
        return x,y
    end
    return x,y
end
