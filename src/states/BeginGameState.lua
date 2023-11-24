BeginGameState = Class{__includes = BaseState}

function BeginGameState:init()
    self.board = Board(WINDOW.VIRTUAL_WIDTH - 350, 45)
    self.levelLabelY = -64
end

function BeginGameState:enter()
    Timer.tween(2, {
        [self] = {levelLabelY = WINDOW.VIRTUAL_HEIGHT / 2 - 8}
    })
    
    -- after that, pause for one second with Timer.after
    :finish(function()
        Timer.after(1, function()
            
            -- then, animate the label going down past the bottom edge
            Timer.tween(2, {
                [self] = {levelLabelY = WINDOW.VIRTUAL_HEIGHT + 30}
            })
            
            -- once that's complete, we're ready to play!
            :finish(function()
                gStateMachine:change('play', {
                    board = self.board
                })
            end)
        end)
    end)
end

function BeginGameState:update(dt)
    Timer.update(dt)
end

function BeginGameState:render()
    -- render Level # label and background rect
    love.graphics.setColor(95/255, 205/255, 228/255, 200/255)
    love.graphics.rectangle('fill', 0, self.levelLabelY - 8, WINDOW.VIRTUAL_WIDTH, 48)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(gFonts['large'])
    love.graphics.printf('Level ' .. tostring(1), 0, self.levelLabelY, WINDOW.VIRTUAL_WIDTH, 'center')
end