local M = {}

M.elements = {}

M.Box = {
    active = true,
    relative = false,
    parent = nil,
    x = 0,
    y = 0,
    width = 100,
    height = 100,
    listArangement = "vertical",
    outerPadVertical = 0,
    outerPadHorizontal = 0,
    elements = {},
}

function M.Box:new(box, parent)
    local b = box or {}
    self.__index = self
    setmetatable(b, self)

    local elements = M.elements
    if parent then
        elements = parent.elements
        b.parent = parent
    end
    table.insert(elements, b)

    return b
end

function M.Box:draw()
    local color = self.color or { 0, 0, 0 }
    love.graphics.setColor(color)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end

function M:draw(box)
    local elements = self.elements
    if box then
        elements = box.elements
        love.graphics.push()
        love.graphics.translate(box.x, box.y)
    end

    for _, element in ipairs(elements) do
        if element.draw then
            element:draw()
        end
        if element.elements and #element.elements > 0 then
            self.draw(self, element)
        end
    end

    if box then
        love.graphics.pop()
    end
end

function M:nestedBoxesDemo()
    local mainBox = {
        x = 10,
        y = 10,
        width = 150,
        height = 350,
    }
    self.Box:new(mainBox)

    local secondaryBox1 = self.Box:new(nil, mainBox) -- nil gives the default box
    secondaryBox1.color = { 1, 0, 0 }

    local tertiaryBox1 = self.Box:new(nil, secondaryBox1)
    tertiaryBox1.width, tertiaryBox1.height = 20, 20
    tertiaryBox1.color = { 0, 0, 1 }

    local tertiaryBox2 = {
        color = { 1, 0, 1 },
        x = 5,
        y = 25,
        width = 30,
        height = 60,
    }
    self.Box:new(tertiaryBox2, secondaryBox1)

    local secondaryBox2 = {
        x = 10,
        y = 110,
        width = 10,
        height = 10,
        color = { 1, 1, 1 },
    }
    self.Box:new(secondaryBox2, mainBox)
end

return M
