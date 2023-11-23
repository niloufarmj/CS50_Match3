require 'src/Dependencies'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

local birds = {}
local startTime
local birdImage

function love.load()
    birdImage = love.graphics.newImage("assets/bird.png")
    

    push:setupScreen(WINDOW.VIRTUAL_WIDTH, WINDOW.VIRTUAL_HEIGHT, WINDOW.WINDOW_WIDTH, WINDOW.WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
    }

    gStateMachine:change('start')

    startTime = 0
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    gStateMachine:update(dt)
    Timer.update(dt)

end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], 0, 0)

    gStateMachine:render()

    push:finish()
end