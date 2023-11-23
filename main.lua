require 'src/Dependencies'

WINDOW = {
    VIRTUAL_WIDTH = 350,
    VIRTUAL_HEIGHT = 200,
    WINDOW_WIDTH = 1050,
    WINDOW_HEIGHT = 600
}

-- seconds it takes to move each step
MOVEMENT_TIME = 2

local birdImage
local birdX
local birdY
local movements 

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

    for k, movement in pairs(movements) do
        movement.reached = false
    end

    birdX = 0
    birdY = 0

    baseX , baseY = birdX, birdY
    timer = 0
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
    timer = math.min(MOVEMENT_TIME, timer + dt)

    for i, movement in ipairs(movements) do
        if not movement.reached then
            birdX, birdY =
                baseX + (movement.x - baseX) * timer / MOVEMENT_TIME,
                baseY + (movement.y - baseY) * timer / MOVEMENT_TIME
            
            -- flag movement as reached if we've reached the movement time and set the
            -- base point as the new current point
            if timer == MOVEMENT_TIME then
                movement.reached = true
                baseX, baseY = movement.x, movement.y
                timer = 0
            end

            -- only need to calculate first unreached movement we iterate over
            break
        end
    end
end

-- Linear interpolation function
function lerp(a, b, t)
    return (1 - t) * a + t * b
end

function love.draw()
    push:start()

    love.graphics.draw(gTextures['background'], 0, 0)
    love.graphics.draw(birdImage, birdX, birdY)

    push:finish()
end