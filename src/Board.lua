Board = Class{}

function Board:init(x, y)
    self.x = x
    self.y = y
    self.matches = {}

    self:initializeTiles()
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 6 do
        
        table.insert(self.tiles, {})

        for tileX = 1, 6 do
            
            -- create a new tile at X,Y with a random color and variety
            table.insert(self.tiles[tileY], Tile(tileX, tileY, math.random(5), math.random(7)))
        end
    end

    while self:calculateMatches() do
        
        self:initializeTiles()
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
    for _, match in ipairs(self.matches) do
        for _, tile in ipairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
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
                tile = Tile(x, y, math.random(5), math.random(7))
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


function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[y] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end