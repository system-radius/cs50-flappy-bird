--[[
  For customization / assignment:
  - make pipe gaps slightly random
  - make pipe intervals slightly random
  - award players with medals based on their score
  - implement a pause feature 
]]

push = require 'res/lua/push'
Class = require 'res/lua/class'

require 'Bird'
require 'Pipe'
require 'PipePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/TitleScreenState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/CountDownState'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- For parallax illusion
local BG_SPEED = 30
local GROUND_SPEED = 60

local BG_LOOP = 413

local PIPES_FREQUENCY = 2

local bg = love.graphics.newImage('res/img/background.png')
local ground = love.graphics.newImage('res/img/ground.png')

local bgX = 0
local groundX = 0

function love.load()
  love.window.setTitle('Flappy Bird')

  -- Seed the randomizaztion.
  math.randomseed(os.time())

  --Initialize fonts for display
  smallFont = love.graphics.newFont('res/font.ttf', 8)
  mediumFont = love.graphics.newFont('res/flappy.ttf', 14)
  flappyFont = love.graphics.newFont('res/flappy.ttf', 28)
  hugeFont = love.graphics.newFont('res/flappy.ttf', 56)
  love.graphics.setFont(flappyFont)

  love.graphics.setDefaultFilter('nearest', 'nearest')

  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    fullscreen = false,
    resizable = true,
    vsync = true
  })

  -- Custom keys pressed.
  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}

  gStateMachine = StateMachine{
    ['title'] = function() return TitleScreenState() end,
    ['play'] = function() return PlayState() end,
    ['score'] = function() return ScoreState() end,
    ['count'] = function() return CountDownState() end
  }

  gStateMachine:change('title')

  -- Initialize sound files
  gSounds = {
    ['jump'] = love.audio.newSource('res/snd/jump.wav', 'static'),
    ['explosion'] = love.audio.newSource('res/snd/explosion.wav', 'static'),
    ['hurt'] = love.audio.newSource('res/snd/hurt.wav', 'static'),
    ['score'] = love.audio.newSource('res/snd/score.wav', 'static'),
    ['pause'] = love.audio.newSource('res/snd/pause.wav', 'static'),
    ['music'] = love.audio.newSource('res/snd/marios_way.mp3', 'static')
  }

  gSounds['music']:setLooping(true)
  gSounds['music']:play()

  gPaused = false

end

function love.resize(w, h)
  push:resize(w, h)
end

function love.keypressed(key)

  -- Track all of the keys that were pressed.
  love.keyboard.keysPressed[key] = true

  if key == 'escape' then
    love.event.quit()
  end
end

function love.mousepressed(x, y, button)
  love.mouse.buttonsPressed[button] = true
  lastButtonPressed = button
end 

function love.keyboard.wasPressed(key)
  return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(button)
  return love.mouse.buttonsPressed[button]
end

function love.update(dt)

  if not gPaused then
    -- Scroll the background and ground regardless of state
    -- Update the background and the ground for the parallax effect
    bgX = (bgX + BG_SPEED * dt) % BG_LOOP
    groundX = (groundX + GROUND_SPEED * dt) % VIRTUAL_WIDTH
  end

  -- Update the current state
  gStateMachine:update(dt)

  -- Flush the key presses
  love.keyboard.keysPressed = {}
  love.mouse.buttonsPressed = {}

end

function love.draw()
  push:start()

  love.graphics.draw(bg, -bgX, 0)
  gStateMachine:render()
  love.graphics.draw(ground, -groundX, VIRTUAL_HEIGHT - 16)

  push:finish()
end