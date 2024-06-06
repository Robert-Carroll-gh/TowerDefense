local M = {}

M.elements = {}
M.placing = nil

-- preventing errors from nil injection for other functions
---@class sideBar
local sideBar = nil

function M.loadGameMenu()
    if sideBar == nil then
        sideBar = {
            x = 5,
            y = 10,
            width = 75,
            height = 350,
        }
        M.Box:new(sideBar)
    else
        sideBar.elements = {}
    end

    local towerMenuButton = {
        x = 5,
        y = 15,
        width = 50,
        height = 50,
        color = { 0, 0, 1 },
    }
    M.Box:new(towerMenuButton, sideBar)
    towerMenuButton:newText "Place\nTower"
    towerMenuButton.onClick = M.loadTowerMenu
end

function M.loadTowerMenu()
    sideBar.elements = {}

    local backButton = {
        x = 5,
        y = 15,
        width = 50,
        height = 50,
        color = { 1, 0, 0 },
    }
    M.Box:new(backButton, sideBar)
    backButton:newText "Back"
    backButton.onClick = function()
        M.placing = nil
        M.loadGameMenu()
    end

    local towerButtonTemplate = {
        x = 5,
        y = 70,
        width = 50,
        height = 50,
        color = { 0, 0, 1 },
    }
    M.Box:new(towerButtonTemplate, sideBar)

    local offset = 5
    local i = 0

    --TODO sort tower type buttons. by cost or alphabetical
    for name, tower in pairs(World.towerHandler.types) do
        i = i + 1
        local button = {
            y = backButton.y + (i * (backButton.height + offset)),
        }
        if tower.color then
            button.color = tower.color
        end
        towerButtonTemplate:new(button, sideBar)
        button:newText(name)
        button.onClick = function()
            M.placing = { object = tower, type = "tower", name = name }
        end
    end
end

M.canPlace = function()
    return true
end

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

function M.Box:getAbsolutePos()
    if self.parent == nil then
        return self.x, self.y
    else
        local parentX, parentY = M.Box.getAbsolutePos(self.parent)
        return parentX + self.x, parentY + self.y
    end
end

function M:processClick(x, y, mouseButton, box)
    local elements = self.elements
    if box then
        elements = box.elements
    end
    local clickedSomeGui = false
    for _, element in ipairs(elements) do
        local minX, minY = element:getAbsolutePos()
        local maxX, maxY = minX + element.width, minY + element.height
        if x >= minX and y >= minY and x <= maxX and y <= maxY then
            clickedSomeGui = true
            pcall(element.onClick)
            M:processClick(x, y, mouseButton, element)
        end
    end
    if clickedSomeGui == false and box == nil and M.placing ~= nil then
        if M.canPlace() and mouseButton == 1 then
            M.placeObject(x, y)
        end
    end
    return clickedSomeGui
end

function M.placeObject(x, y)
    if M.placing.type == "tower" then
        World.towerHandler:new(M.placing.name, x, y)
    end
end

function M.Box:new(box, parent)
    local b = box or {}
    b.elements = {}
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

function M.Box:newText(text, x, y)
    local b = M.Box:new(nil, self)
    b.width, b.height = 0, 0
    b.x = x or 0
    b.y = y or 0
    b.draw = function(self)
        local color = self.color or { 0, 0, 0 }
        love.graphics.setColor(color)
        love.graphics.print(text, self.x, self.y)
    end
    return b
end

function M.Box:outline()
    local color = self.color or { 0, 0, 0 }
    love.graphics.setColor(color)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
end
M.Box.draw = M.Box.outline

function M:draw(box)
    local elements = self.elements
    if box then
        elements = box.elements
        love.graphics.push()
        love.graphics.translate(box.x, box.y)
    else
        if self.placing then
            self:drawPlacement()
        end
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

function M:drawPlacement()
    local object = self.placing.object
    local mx, my = love.mouse.getPosition()
    local x = mx - object.width / 2
    local y = my - object.height / 2
    love.graphics.setBlendMode "screen"
    object:draw(mx, my)
    love.graphics.setBlendMode "alpha"
    if self.placing.type == "tower" and M.canPlace() == false then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle("fill", x, y, object.width, object.height)
    end
end

function M:onClickDemo()
    local mainBox = {
        x = 10,
        y = 10,
        width = 150,
        height = 350,
    }
    self.Box:new(mainBox)
    mainBox.onClick = function()
        print "Clicked"
        return true
    end
    mainBox:newText("test", 15, 60)
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
