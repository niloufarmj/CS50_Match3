Tile = Class{}

function Tile:init(x, y, color, variety)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety

    self.highlighted = false
    self.selected = false
end

function Tile:render(x, y)
    
    if self.selected then 
        -- Draw the border square
        love.graphics.setColor({0, 255, 0, 255})
        love.graphics.rectangle('line', self.x + x, self.y + y, 32, 32)
    elseif self.highlighted then
        love.graphics.setColor({255, 0, 0, 255})
        love.graphics.rectangle('line', self.x + x, self.y + y, 32, 32)
    end

    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
end

function Tile:setHighlighted(highlighted)
    self.highlighted = highlighted
end

function Tile:setSelected(selected)
    self.selected = selected
end