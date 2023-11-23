StartState = Class{__includes = BaseState}

function StartState:init()
    -- currently selected menu item
    self.currentMenuItem = 1

    -- colors we'll use to change the title text
    self.colors = {
        {217 / 255, 87 / 255, 99 / 255, 1},
        {95 / 255, 205 / 255, 228 / 255, 1},
        {251 / 255, 242 / 255, 54 / 255, 1},
        {118 / 255, 66 / 255, 138 / 255, 1},
        {153 / 255, 229 / 255, 80 / 255, 1},
        {223 / 255, 113 / 255, 38 / 255, 1}
    }

    -- letters of MATCH 3 and their spacing relative to the center
    self.letterTable = {
        {'M', -108},
        {'A', -64},
        {'T', -28},
        {'C', 2},
        {'H', 40},
        {'3', 112}
    }

    -- Initialize the initial color indices for each letter
    self.letterColorIndices = {}
    for i = 1, #self.letterTable do
        self.letterColorIndices[i] = i
    end

    -- Initialize the color-change timers for each letter
    self.letterTimers = {}
    for i = 1, #self.letterTable do
        self.letterTimers[i] = Timer.every(0.2 + (i * 0.05), function()
            self.letterColorIndices[i] = (self.letterColorIndices[i] % #self.colors) + 1
        end)
    end
end

function StartState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('begin-game')
    end
    Timer.update(dt)
end

function StartState:render()
    -- Render the "MATCH 3" text with shadow
    love.graphics.setFont(gFonts['large'])

    for i, letterData in ipairs(self.letterTable) do
        local letter = letterData[1]
        local spacing = letterData[2]
        local colorIndex = self.letterColorIndices[i]
        local color = self.colors[colorIndex]

        -- Render the shadow text with an offset of 1 pixel
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(letter, WINDOW.VIRTUAL_WIDTH / 2 + spacing - 3, WINDOW.VIRTUAL_HEIGHT / 2 - 29)

        -- Render the main text
        love.graphics.setColor(color)
        love.graphics.print(letter, WINDOW.VIRTUAL_WIDTH / 2 + spacing - 6, WINDOW.VIRTUAL_HEIGHT / 2 - 30)
        
    end

    -- Render the "Click Enter to play" text with shadow
    love.graphics.setFont(gFonts['medium'])

    local playText = "Press Enter to play"
    local playTextX = (WINDOW.VIRTUAL_WIDTH - gFonts['medium']:getWidth(playText)) / 2
    local playTextY = WINDOW.VIRTUAL_HEIGHT / 2 + 30

    -- Render the shadow text with an offset of 3 pixels
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(playText, playTextX + 1, playTextY + 1)

    -- Render the main text
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.print(playText, playTextX, playTextY)
end