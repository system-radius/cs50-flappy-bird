Bird = Class{}

-- The rate of falling.
local GRAVITY = 20

function Bird:init()
  
  self.image = love.graphics.newImage('res/img/bird.png')

  self.width = self.image:getWidth()
  self.height = self.image:getHeight()

  self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
  self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

  self.dy = 0

end

function Bird:update(dt)

  -- Increment the change in y with the GRAVITY
  self.dy = self.dy + GRAVITY * dt

  if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
    gSounds['jump']:play()
    self.dy = -5
  end

  -- Apply the velocity to the object
  self.y = self.y + self.dy

  if self.y > VIRTUAL_HEIGHT - self.height then
    self.y = VIRTUAL_HEIGHT - self.height
  elseif self.y < 0 then
    self.y = 0
  end

end

function Bird:render()
  love.graphics.draw(self.image, self.x, self.y)
end

function Bird:collides(pipe)
  
  -- Shift the coordinates of this bird by 2 on all directions
  -- so as to be more "forgiving" with regards to collisions.
  if (self.x + 2) > pipe.x + pipe.width or pipe.x > (self.x + 2) + (self.width - 4) then
    return false
  end

  if (self.y + 2) > pipe.y + pipe.height or pipe.y > (self.y + 2) + (self.height - 4) then
    return false
  end

  return true
end