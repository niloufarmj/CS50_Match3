

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    self.labelY = -64
    self.enterText = ''
end

function GameOverState:enter(params)
    self.score = params.score 
    Timer.tween(2, {
        [self] = {labelY = WINDOW.VIRTUAL_HEIGHT / 2 - 50}
    }):finish(function()
        self.enterText = 'Click Enter to Play Again!'
    end)
end

function GameOverState:update(dt)
    if love.keyboard.keysPressed['enter'] or love.keyboard.keysPressed['return'] then
        gStateMachine:change('begin-game', {
            level = 1,
            score = 0 
        })
    end
    Timer.update(dt)
end

function GameOverState:render()
    love.graphics.setColor(240/255, 120/255, 100/255, 200/255)
    love.graphics.rectangle('fill', 0, self.labelY - 8, WINDOW.VIRTUAL_WIDTH, 100)

    love.graphics.setFont(gFonts['large'])
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf('Game Over', 0, self.labelY + 10, WINDOW.VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.printf('Total Score: ' .. self.score, 0, self.labelY + 50, WINDOW.VIRTUAL_WIDTH, 'center')

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.printf(self.enterText, 1, WINDOW.VIRTUAL_HEIGHT / 2 + 50 + 1, WINDOW.VIRTUAL_WIDTH, 'center')

    -- Render the main text
    love.graphics.setColor(0, 1, 1, 1)
    love.graphics.printf(self.enterText, 0, WINDOW.VIRTUAL_HEIGHT / 2 + 50, WINDOW.VIRTUAL_WIDTH, 'center')
end