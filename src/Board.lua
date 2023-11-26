Board = Class{}

function Board:init(x, y, l)
    self.x = x
    self.y = y
    self.level = l
    self.matches = {}

    self.resetText = ''

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 6 do
        
        table.insert(self.tiles, {})

        for tileX = 1, 6 do
            
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(5), math.min(math.random(self.level), 7), math.random(100) <= 5))
        end
    end

    while self:calculateMatches() do
        self:initializeTiles()
    end

    if not self:findMatches() then
        self:initializeTiles()
    end
end

function Board:reset()
    if not self:findMatches() then
        self.resetText = 'No Other Matches Found!'
        Timer.after(1, function()
            self.resetText = ''
            self:initializeTiles()
        end)
    end
end

function Board:calculateMatches()
    local matches = {}

    for y = 1, 6 do
        local matchNum = 1
        local colorToMatch = self.tiles[y][1].color

        for x = 2, 6 do
            local currentTile = self.tiles[y][x]
            
            if currentTile.color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = currentTile.color

                if matchNum >= 3 then
                    local match = {}

                    for x2 = x - 1, x - matchNum, -1 do
                        table.insert(match, self.tiles[y][x2])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if x >= 5 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for x = 6, 6 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    for x = 1, 6 do
        local matchNum = 1
        local colorToMatch = self.tiles[1][x].color

        for y = 2, 6 do
            local currentTile = self.tiles[y][x]

            if currentTile.color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = currentTile.color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        table.insert(match, self.tiles[y2][x])
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                if y >= 5 then
                    break
                end
            end
        end

        if matchNum >= 3 then
            local match = {}

            for y = 6, 6 - matchNum + 1, -1 do
                table.insert(match, self.tiles[y][x])
            end

            table.insert(matches, match)
        end
    end

    self.matches = matches

    return #self.matches > 0 and self.matches or false
end


function Board:removeMatches()
    local totalScore = 0  -- Variable to track the total score earned
    
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil

            -- Check if the tile is shiny
            if tile.isShiny then
                -- Destroy the entire row and add score for each tile
                for x = 1, 6 do
                    if self.tiles[tile.gridY][x] then
                        totalScore = totalScore + (self.tiles[tile.gridY][x].variety + 1) * 25
                        self.tiles[tile.gridY][x] = nil
                    end
                end
            else
                totalScore = totalScore + (tile.variety + 1) * 25
            end
        end
    end

    self.matches = nil
    
    return totalScore  -- Return the total score earned
end


function Board:getFallingTiles()
    local tweens = {}

    for x = 1, 6 do
        local space = false
        local spaceY = 0

        local y = 6
        while y >= 1 do
            local tile = self.tiles[y][x]

            if space then
                if tile then
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY
                    self.tiles[y][x] = nil

                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    space = false
                    y = spaceY
                    spaceY = 0
                end
            elseif tile == nil then
                space = true

                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    for x = 1, 6 do
        for y = 6, 1, -1 do
            local tile = self.tiles[y][x]

            if not tile then
                tile = Tile(x, y, math.random(5), math.min(math.random(self.level), 7), math.random(100) <= 5)
                tile.y = -32
                self.tiles[y][x] = tile

                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end

    return tweens
end


function Board:findMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 6 do
        for x = 1, 5 do
            -- Check if swapping with the right neighbor creates a match
            self:swapTiles(x, y, x + 1, y)
            if self:isMatch(x, y) then
                -- Add the tiles to the match table
                table.insert(matches, {self.tiles[y][x], self.tiles[y][x + 1]})
            end
            -- Swap back the tiles
            self:swapTiles(x, y, x + 1, y)
        end
    end

    -- vertical matches
    for x = 1, 6 do
        for y = 1, 5 do
            -- Check if swapping with the bottom neighbor creates a match
            self:swapTiles(x, y, x, y + 1)
            if self:isMatch(x, y) then
                -- Add the tiles to the match table
                table.insert(matches, {self.tiles[y][x], self.tiles[y + 1][x]})
            end
            -- Swap back the tiles
            self:swapTiles(x, y, x, y + 1)
        end
    end

    return #matches > 0 and matches or false
end

function Board:swapTiles(x1, y1, x2, y2)
    local tempTile = self.tiles[y1][x1]
    self.tiles[y1][x1] = self.tiles[y2][x2]
    self.tiles[y2][x2] = tempTile
end

function Board:isMatch(x, y)
    local color = self.tiles[y][x].color

    -- Check for horizontal match
    local matchNum = 1
    local left = x - 1
    local right = x + 1

    while left > 0 and self.tiles[y][left].color == color do
        matchNum = matchNum + 1
        left = left - 1
    end

    while right <= 6 and self.tiles[y][right].color == color do
        matchNum = matchNum + 1
        right = right + 1
    end

    if matchNum >= 3 then
        return true
    end

    -- Check for vertical match
    matchNum = 1
    local up = y - 1
    local down = y + 1

    while up > 0 and self.tiles[up][x].color == color do
        matchNum = matchNum + 1
        up = up - 1
    end

    while down <= 6 and self.tiles[down][x].color == color do
        matchNum = matchNum + 1
        down = down + 1
    end

    return matchNum >= 3
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end