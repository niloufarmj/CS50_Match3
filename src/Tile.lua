Tile = Class{}

function Tile:init(x, y, color, variety, isShiny)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.isShiny = isShiny
end

function Tile:render(x, y)
    

    if self.isShiny then
        love.graphics.setColor(255, 255, 0, 0.7)

        -- Draw the rectangle to highlight the shiny tile
        love.graphics.rectangle('fill', self.x + x - 1, self.y + y - 1, 34, 34, 4)

    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end
