PlayState = Class{__includes = BaseState}

function PlayState:init()
    
end

function PlayState:enter(params)
    self.board = params.board or GenerateBoard()
end

function PlayState:update(dt)
    Timer.update(dt)
end

function PlayState:render()
    -- Draw the tiles matrix
    self:renderBoard()
end

function PlayState:renderBoard() 
    local matrixWidth = 6
    local matrixHeight = 6

    for row = 1, matrixHeight do
        for col = 1, matrixWidth do
            local tile = self.board[row][col]
            love.graphics.draw(gTextures['main'], gFrames['tiles'][tile.tile], tile.x + 160, tile.y + 45)
        end
    end
end