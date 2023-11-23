require 'src/Dependencies'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

-- seconds it takes to move each step
MOVEMENT_TIME = 2

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

    startTime = 0

    movements = { -- Sequence of movements
        {x = WINDOW.VIRTUAL_WIDTH - birdImage:getWidth(), y = 0},
        {x = WINDOW.VIRTUAL_WIDTH - birdImage:getWidth(), y = WINDOW.VIRTUAL_HEIGHT - birdImage:getHeight()},
        {x = 0, y = WINDOW.VIRTUAL_HEIGHT - birdImage:getHeight()},
        {x = 0, y = 0}
    }


    bird = {x = 0, y = 0}

    Timer.tween(MOVEMENT_TIME, {
        [bird] = movements[1]
    })
    :finish(function()
        Timer.tween(MOVEMENT_TIME, {
            [bird] = movements[2]
        })
        :finish(function()
            Timer.tween(MOVEMENT_TIME, {
                [bird] = movements[3]
            })
            :finish(function()
                Timer.tween(MOVEMENT_TIME, {
                    [bird] = movements[4]
                })
            end)
        end)
    end)
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
    Timer.update(dt)
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], 0, 0)
    love.graphics.draw(birdImage, bird.x, bird.y)

    push:finish()
end