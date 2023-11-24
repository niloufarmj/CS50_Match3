require 'src/Dependencies'

WINDOW = {
    VIRTUAL_WIDTH = 512,
    VIRTUAL_HEIGHT = 288,
    WINDOW_WIDTH = 1280,
    WINDOW_HEIGHT = 720
}

-- seconds it takes to move each step
MOVEMENT_TIME = 2

function love.load()

    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WINDOW_WIDTH, WINDOW.WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['begin-game'] = function () return BeginGameState() end,
        ['play'] = function () return PlayState() end
    }

    gStateMachine:change('start')
    love.keyboard.keysPressed = {}

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    gStateMachine:update(dt)
    Timer.update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], 0, 0)
    gStateMachine:render()

    push:finish()
end
