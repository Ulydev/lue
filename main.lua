lue = require "lue" --require the library

function love.load()
  
  font = {
    small = love.graphics.newFont(14),
    big = love.graphics.newFont(64)
  }
  
end

function love.update(dt)
  
  lue:update(dt)
  
  local dir = (love.keyboard.isDown("left") and -1) or (love.keyboard.isDown("right") and 1) or 0
  lue:setSpeed(lue:getSpeed() + dt*dir*100)
  
end

function love.draw()
  
  love.graphics.setBackgroundColor(lue:getColor(80, 50))
  
  
  
  love.graphics.setColor(lue:getColor(100, 120))
  
  love.graphics.setFont(font.big)
  
  love.graphics.printf("Speed\n" .. math.floor( lue:getSpeed() ), 0, love.graphics.getHeight()*.5-200, love.graphics.getWidth(), "center")
  love.graphics.printf("Hue\n" .. math.floor( lue:getHue() ), 0, love.graphics.getHeight()*.5-20, love.graphics.getWidth(), "center")
  
  
  
  love.graphics.setColor(lue:getColor(100, 80))
  
  love.graphics.setFont(font.small)
  
  love.graphics.printf("Left and Right to change speed", 0, love.graphics.getHeight()-120, love.graphics.getWidth(), "center")
  
end