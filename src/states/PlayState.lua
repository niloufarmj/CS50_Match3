PlayState = Class{__includes = BaseState}

function PlayState:init()
    
end

function PlayState:enter(params)
    self.board = params.board
    self.selectedX = 1
    self.selectedY = 1
end

function PlayState:update(dt)
    Timer.update(dt)

    -- Move the selected tile based on input
    if love.keyboard.keysPressed['left'] then
        self.selectedX = math.max(1, self.selectedX - 1)
    elseif love.keyboard.keysPressed['right'] then
        self.selectedX = math.min(6, self.selectedX + 1)
    elseif love.keyboard.keysPressed['up'] then
        self.selectedY = math.max(1, self.selectedY - 1)
    elseif love.keyboard.keysPressed['down'] then
        self.selectedY = math.min(6, self.selectedY + 1)
    end

    -- Update tile highlighting
    for y = 1, #self.board.tiles[1] do
        for x = 1, #self.board.tiles do
            local tile = self.board.tiles[x][y]
            tile:setHighlighted(x == self.selectedY and y == self.selectedX)
        end
    end

    if love.keyboard.keysPressed['return'] or love.keyboard.keysPressed['enter'] then
        -- Handle tile selection logic here
        local selectedTile = self.board.tiles[self.selectedY][self.selectedX]
        selectedTile:setSelected(true)
        selectedTile:setHighlighted(false)
        -- Do something with the selected tile
        -- For now, let's print its coordinates
        print("Selected Tile:", selectedTile.gridX, selectedTile.gridY)
    end
end

function PlayState:render()
    -- Draw the tiles matrix
    self.board:render()
end

