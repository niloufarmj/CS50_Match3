PlayState = Class{__includes = BaseState}

function PlayState:init()
    
    self.boardHighlightX = 0
    self.boardHighlightY = 0

    -- timer used to switch the highlight rect's color
    self.rectHighlighted = false

    self.canInput = true

    self.highlightedTile = nil

    self.score = 0
    self.timer = 60
    
end

function PlayState:enter(params)
    

    -- spawn a board and place it toward the right
    self.board = params.board or Board(WINDOW.VIRTUAL_WIDTH - 272, 16)

end

function PlayState:update(dt)

    if self.canInput then
        -- move cursor around based on bounds of grid, playing sounds
        if love.keyboard.keysPressed['up'] then
            self.boardHighlightY = math.max(0, self.boardHighlightY - 1)
            
        elseif love.keyboard.keysPressed['down'] then
            self.boardHighlightY = math.min(6, self.boardHighlightY + 1)
            
        elseif love.keyboard.keysPressed['left'] then
            self.boardHighlightX = math.max(0, self.boardHighlightX - 1)
            
        elseif love.keyboard.keysPressed['right'] then
            self.boardHighlightX = math.min(6, self.boardHighlightX + 1)
            
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
                    -- self:calculateMatches()
                end)
            end
        end
    end

    Timer.update(dt)
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
            (self.highlightedTile.gridY - 1) * 32 + 45, 32, 32, 4)

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
        self.boardHighlightY * 32 + 45, 32, 32, 4)

end