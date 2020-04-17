Pipe = Class{}

PIPE_HEIGHT = 288
PIPE_WIDTH = 70
PIPE_SPEED = 60

local PIPE_IMAGE = love.graphics.newImage('res/img/pipe.png')

function Pipe:init(pos, y)

  self.pos = pos

  self.x = VIRTUAL_WIDTH
  self.y = y

  self.width = PIPE_IMAGE:getWidth()
  self.height = PIPE_HEIGHT

  -- No need for height.

end 

function Pipe:render()
  
  love.graphics.draw(PIPE_IMAGE, self.x,
    (self.pos == 'top' and self.y + PIPE_HEIGHT or self.y),
    0, -- rotation
    1, -- X scale
    self.pos == 'top' and -1 or 1) -- Y scale
--[[
  if self.pos == 'top' then
    love.graphics.draw(PIPE_IMAGE, self.x, self.y + PIPE_HEIGHT, -1)
  else
    love.graphics.draw(PIPE_IMAGE, self.x, self.y, 1)
  end]]
end