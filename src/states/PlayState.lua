PlayState = Class{__includes = BaseState}

BASE_SCORE = 2000

function PlayState:init()
    
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    self.canInput = true

    self.highlightedTile = nil

    self.score = 0

    self.timer = 30  -- Set the initial timer value to 120 seconds (2 minutes)
    
    -- Define the tween for the timer countdown
    Timer.every(2, function()
        self.timer = self.timer - 1
    end)
    
end

function PlayState:enter(params)
    self.level = params.level 
    self.maxScore = BASE_SCORE + 1500 * self.level
    self.sumScore = params.score
    -- spawn a board and place it toward the right
    self.board = params.board or Board(WINDOW.VIRTUAL_WIDTH - 272, 16, self.level)
end

function PlayState:update(dt)
    
    if self.score >= self.maxScore then
        gStateMachine:change('begin-game', {
            level = self.level + 1,
            score = self.sumScore + self.score
        })
    end

    if self.timer <= 0 then
        
        -- clear timers from prior PlayStates
        Timer.clear()
        
        gStateMachine:change('game-over', {
            score = self.sumScore + self.score
        })
    end

    if self.canInput then
        -- move cursor around based on bounds of grid, playing sounds
        if love.keyboard.keysPressed['up'] then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            
        elseif love.keyboard.keysPressed['down'] then
            self.boardHighlightY = math.min(5, self.boardHighlightY + 1)
            
        elseif love.keyboard.keysPressed['left'] then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            
        elseif love.keyboard.keysPressed['right'] then
            self.boardHighlightX = math.min(5, self.boardHighlightX + 1)
            
        end

        -- if we've pressed enter, to select or deselect a tile...
        if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
            
            -- if same tile as currently highlighted, deselect
            local x = self.boardHighlightX + 1
            local y = self.boardHighlightY + 1
            
            -- if nothing is highlighted, highlight current tile
            if not self.highlightedTile then
                self.highlightedTile = self.board.tiles[y][x]

            -- if we select the position already highlighted, remove highlight
            elseif self.highlightedTile == self.board.tiles[y][x] then
                self.highlightedTile = nil

            elseif math.abs(self.highlightedTile.gridX - x) + math.abs(self.highlightedTile.gridY - y) > 1 then
                
                self.highlightedTile = nil
            else
                
                -- swap grid positions of tiles
                local tempX = self.highlightedTile.gridX
                local tempY = self.highlightedTile.gridY

                local newTile = self.board.tiles[y][x]

                self.highlightedTile.gridX = newTile.gridX
                self.highlightedTile.gridY = newTile.gridY
                newTile.gridX = tempX
                newTile.gridY = tempY

                -- swap tiles in the tiles table
                self.board.tiles[self.highlightedTile.gridY][self.highlightedTile.gridX] =
                    self.highlightedTile

                self.board.tiles[newTile.gridY][newTile.gridX] = newTile

                -- tween coordinates between the two so they swap
                Timer.tween(0.1, {
                    [self.highlightedTile] = {x = newTile.x, y = newTile.y},
                    [newTile] = {x = self.highlightedTile.x, y = self.highlightedTile.y}
                })
                
                :finish(function()
                    self:calculateMatches()
                end)
            end
        end
    end

    Timer.update(dt)
end

function PlayState:calculateMatches()
    self.highlightedTile = nil

    local matches = self.board:calculateMatches()

    if matches then
        
        local totalScore = self.board:removeMatches()
        self.score = self.score + totalScore

        self.timer = self.timer + (#matches * 1)

        local tilesToFall = self.board:getFallingTiles()

        local fallDuration = 1
        Timer.tween(fallDuration, tilesToFall)
            :finish(function()
                self:calculateMatches()
            end)
    else
        self.canInput = true
    end
end


function PlayState:render()
    -- render board of tiles
    self.board:render()

    -- render highlighted tile if it exists
    if self.highlightedTile then
        
        -- multiply so drawing white rect makes it brighter
        love.graphics.setBlendMode('add')

        love.graphics.setColor(1, 1, 1, 96/255)
        love.graphics.rectangle('fill', (self.highlightedTile.gridX - 1) * 32 + (WINDOW.VIRTUAL_WIDTH - 350),
            (self.highlightedTile.gridY - 1) * 32 + 30, 32, 32, 4)

        -- back to alpha
        love.graphics.setBlendMode('alpha')
    end

    -- render highlight rect color based on timer
    if self.rectHighlighted then
        love.graphics.setColor(217/255, 87/255, 99/255, 1)
    else
        love.graphics.setColor(60/255, 210/255, 155/255, 1)
    end

    -- draw actual cursor rect
    love.graphics.setLineWidth(3)
    love.graphics.rectangle('line', self.boardHighlightX * 32 + (WINDOW.VIRTUAL_WIDTH - 350),
        self.boardHighlightY * 32 + 30, 32, 32, 4)

    local redColor = {225/255, 115/255, 130/255}


    minutes = self.timer / 60
    seconds = self.timer % 60

    if seconds < 10 then
        seconds = '0' .. tostring(seconds)
    end

    love.graphics.setFont(gFonts['large'])

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Timer", 16, 11)
    love.graphics.setColor(redColor)
    love.graphics.print("Timer", 15, 10)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(math.floor(minutes) .. ':' .. seconds, 26, 41)
    love.graphics.setColor(redColor)
    love.graphics.print(math.floor(minutes) .. ':' .. seconds, 25, 40)  

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print("Score", WINDOW.VIRTUAL_WIDTH-84, 11)
    love.graphics.setColor(redColor)
    love.graphics.print("Score", WINDOW.VIRTUAL_WIDTH-85, 10)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(tostring(self.score), WINDOW.VIRTUAL_WIDTH-94, 41, 90, 'center')
    love.graphics.setColor(redColor)
    love.graphics.printf(tostring(self.score), WINDOW.VIRTUAL_WIDTH-95, 40, 90, 'center')  

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf("You Need " .. tostring(self.maxScore) .. " Points To Pass This Level", 1, WINDOW.VIRTUAL_HEIGHT - 29, WINDOW.VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.printf("You Need " .. tostring(self.maxScore) .. " Points To Pass This Level", 0, WINDOW.VIRTUAL_HEIGHT - 30, WINDOW.VIRTUAL_WIDTH, 'center')
end