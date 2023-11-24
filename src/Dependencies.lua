
--
-- libraries
--
Class = require 'lib/class'

push = require 'lib/push'

-- used for timers and tweening
Timer = require 'lib/knife.timer'


-- utility
require 'src/StateMachine'
require 'src/Util'

-- game states
require 'src/states/BaseState'
require 'src/states/BeginGameState'
require 'src/states/GameOverState'
require 'src/states/PlayState'
require 'src/states/StartState'

require 'src/Board'
require 'src/Tile'

gFonts = {
    ['small'] = love.graphics.newFont('assets/font.ttf', 8),
    ['medium'] = love.graphics.newFont('assets/font.ttf', 16),
    ['large'] = love.graphics.newFont('assets/font.ttf', 32)
}

gTextures = {
    ['background'] = love.graphics.newImage('assets/bg4.png'),
    ['main'] = love.graphics.newImage('assets/test.png'),
}

gFrames = {
    ['tiles'] = GenerateTileQuads(gTextures['main'])
}