local M = {}

M.elements = {}
M.placing = nil

-- preventing errors from nil injection for other functions
---@class sideBar
local sideBar = nil
---@class manaBox
local manaBox = nil

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
    if manaBox == nil then
        manaBox = M.Box:new { x = 640, y = 10, width = 150, height = 20, color = { 1, 0.3, 0.3 } }
        local manaText = manaBox:newText(function()
            return (World.mana .. " / " .. World.manaCap)
        end, 5, 2)
        manaText.color = ManaColor
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

    local upgradeTowerButton = {
        x = 5,
        y = 70,
        width = 50,
        height = 50,
        color = { 1, 1, 1 },
    }
    M.Box:new(upgradeTowerButton, sideBar)
    upgradeTowerButton:newText "Upgrade\nTower"
    upgradeTowerButton.onClick = M.loadUpgradeMenu

    local useItemButton = {
        x = 5,
        y = 135,
        width = 50,
        height = 50,
        color = { 1, 0, 1 },
    }
    M.Box:new(useItemButton, sideBar)
    useItemButton:newText "Use\nItem"
    useItemButton.onClick = M.loadItemMenu
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
        if tower.upgradesFrom == nil or tower.upgradesFrom == "none" then
            i = i + 1
            local button = {
                y = backButton.y + (i * (backButton.height + offset)),
            }
            if tower.color then
                button.color = tower.color
            end
            towerButtonTemplate:new(button, sideBar)
            button:newText(name)
            local costText = button:newText(tower.cost or 0, 0, 10)
            costText.color = ManaColor

            button.onClick = function()
                M.placing = { object = tower, type = "tower", name = name }
            end
        end
    end
end

function M.loadUpgradeMenu()
    sideBar.elements = {}

    M.placing = { object = nil, type = "upgrade", name = nil }
    local cost_indicator = sideBar:newText(function()
        if M.placing.object ~= nil then
            return M.placing.object.cost
        end
        return ""
    end)
    cost_indicator.color = ManaColor

    local backButton = {
        x = 5,
        y = 35,
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
end

function M.loadItemMenu()
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

    local itemButtonTemplate = {
        x = 5,
        y = 70,
        width = 50,
        height = 50,
        color = { 0, 0, 1, 0 },
    }
    M.Box:new(itemButtonTemplate, sideBar)

    local offset = 5
    local i = 0
    for itemName, count in pairs(World.itemHandler.pickedUpCounts) do
        i = i + 1
        local button = {
            y = backButton.y + (i * (backButton.height + offset)),
            color = { 0, 0, 1 },
        }
        itemButtonTemplate:new(button, sideBar)
        button:newText(function()
            return World.itemHandler.pickedUpCounts[itemName]
        end)
        button:newText(itemName, 0, 12)
        button.onClick = function()
            M.placing = { object = World.itemHandler.types[itemName], type = "itemUpgrade", name = itemName }
        end
    end
end

M.canPlace = function()
    if M.placing.object ~= nil then
        if M.placing.object.cost ~= nil then
            return World.mana >= M.placing.object.cost
        end
        if M.placing.type == "itemUpgrade" then
            return World.itemHandler.pickedUpCounts[M.placing.name] > 0
        end
        return true
    end
    return false
end

M.Box = {
    active = true,
    relative = false,
    parent = M,
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
    if self.parent == nil or self.parent == M then
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
        if Utils.isPointInRec(x, y, element) then
            clickedSomeGui = true
            if element.onClick ~= nil then
                element.onClick()
            end
            M:processClick(x, y, mouseButton, element)
        end
    end
    if clickedSomeGui == false and box == nil and M.placing ~= nil then
        if M.canPlace() and mouseButton == 1 then
            M.placeObject(x, y)
            if M.placing.object.cost ~= nil then
                World.mana = World.mana - M.placing.object.cost
            end
            if M.placing.type == "itemUpgrade" then
                World.itemHandler.pickedUpCounts[M.placing.name] = World.itemHandler.pickedUpCounts[M.placing.name] - 1
            end
        end
    end
    return clickedSomeGui
end

function M.placeObject(x, y)
    if M.placing.type == "tower" then
        World.towerHandler:new(M.placing.name, x, y)
    elseif M.placing.type == "upgrade" then
        local hoveredTower = M.towerAt(x, y)
        World.towerHandler:new(M.placing.object, hoveredTower.x, hoveredTower.y)
        hoveredTower.kill = true
    elseif M.placing.type == "itemUpgrade" then
        local hoveredTower = M.towerAt(x, y)
        if hoveredTower ~= nil then
            M.placing.object.effect.upgrade(hoveredTower)
        end
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

M.drawStaticText = function(self, text)
    local color = self.color or { 0, 0, 0 }
    love.graphics.setColor(color)
    love.graphics.print(text, self.x, self.y)
end

M.drawDynamicText = function(self, textGetter)
    local color = self.color or { 0, 0, 0 }
    love.graphics.setColor(color)
    love.graphics.print(textGetter(), self.x, self.y)
end

function M.Box:newText(text, x, y)
    local b = M.Box:new(nil, self)
    b.width, b.height = 0, 0
    b.x = x or 0
    b.y = y or 0
    if type(text) == "function" then
        b.draw = function()
            pcall(M.drawDynamicText, b, text)
        end
    else
        b.draw = function()
            pcall(M.drawStaticText, b, text)
        end
    end
    return b
end

function M.Box:outline(x, y)
    local color = self.color or { 0, 0, 0 }
    local x, y = x or self.x, y or self.y
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
    elseif self.placing ~= nil then
        self:drawPlacement()
    end

    for _, element in ipairs(elements) do
        if element.draw then
            element:draw()
        end

        --recursion
        if element.elements and #element.elements > 0 then
            self.draw(self, element)
        end
    end
    if box then
        love.graphics.pop()
    end
end

local updateUpgradePlacement = function()
    local mx, my = love.mouse.getPosition()
    local hoveredTower = M.towerAt(mx, my)
    if hoveredTower ~= nil and hoveredTower.upgradesTo ~= nil and hoveredTower.upgradesTo ~= "none" then
        M.placing.object = hoveredTower.upgradesTo
    else
        M.placing.object = nil
    end
end

function M:update(dt, box)
    local elements = self.elements
    if box then
        elements = box.elements
    elseif self.placing ~= nil then
        if self.placing.type == "upgrade" then
            updateUpgradePlacement()
        end
    end

    for i, element in ipairs(elements) do
        if element.kill == true then
            table.remove(elements, i)
            return "removed a gui element"
        end

        if element.update then
            element:update(dt)
        end

        --recursion
        if element.elements and #element.elements > 0 then
            self.update(self, dt, element)
        end
    end
end

function M.towerAt(x, y)
    for i, tower in ipairs(World.towerHandler.Towers) do
        if Utils.isPointInCenteredRec(x, y, tower) then
            return tower
        end
    end
    return nil
end

function M.itemAt(x, y)
    for i, item in ipairs(World.itemHandler.Items) do
        if Utils.isPointInCenteredRec(x, y, item) then
            return item
        end
    end
end

local drawTowerPlacement = function()
    local object = M.placing.object
    local mx, my = love.mouse.getPosition()
    local x = mx - object.width / 2
    local y = my - object.height / 2
    love.graphics.setBlendMode "screen"
    object:draw(mx, my)
    love.graphics.setBlendMode "alpha"
    if M.canPlace() == false then
        love.graphics.setColor(1, 0, 0, 0.5)
        love.graphics.rectangle("fill", x, y, object.width, object.height)
    end
end

local drawUpgradePlacement = function()
    local object = M.placing.object
    local mx, my = love.mouse.getPosition()
    local hoveredTower = M.towerAt(mx, my)
    if hoveredTower ~= nil and object ~= nil then
        love.graphics.setBlendMode "screen"
        object:draw(hoveredTower.x, hoveredTower.y)
        love.graphics.setBlendMode "alpha"
        if M.canPlace() == false then
            love.graphics.setColor(1, 0, 0, 0.5)
            love.graphics.rectangle("fill", hoveredTower.x, hoveredTower.y, object.width / 2, object.height / 2)
        end
    end
end

function M:drawPlacement()
    if M.placing.type == "tower" then
        drawTowerPlacement()
    elseif M.placing.type == "upgrade" or M.placing.type == "itemUpgrade" then
        drawUpgradePlacement()
    else
        error "unknown placing type"
    end
end

function M:selfDestructDemo()
    local mainBox = {
        x = 10,
        y = 10,
        width = 150,
        height = 350,
    }
    self.Box:new(mainBox)
    mainBox.onClick = function()
        print "self destructing, no one can save me"
        mainBox.kill = true
        return true
    end
    mainBox:newText("test", 15, 60)
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
