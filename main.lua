io.stdout:setvbuf'no' 

lue = require "lue" --require the library

function love.load()
  
  font = {
    small = love.graphics.newFont(14),
    big = love.graphics.newFont(64)
  }
  
  objects = {}
  
  love.window.setTitle("Press space")
  
end

function love.update(dt)
  
  lue:update(dt)
  
  for i = #objects, 1, -1 do
    local o = objects[i]
    o.color:update(dt)
    o.x, o.y = o.x + o.speed.x * dt, o.y + o.speed.y * dt
    if o.x < -300 or o.x > love.graphics.getWidth()+300 or o.y < -300 or o.y > love.graphics.getHeight()+300 then
      table.remove(objects, i)
    end
  end
  
end

function love.draw()
  
  love.graphics.setBackgroundColor(lue:getHueColor(80, 50))
  
  for i = 1, #objects do
    local o = objects[i]
    love.graphics.setColor(o.color:getColor())
    print(o.color:getColor()[4])
    love.graphics.rectangle("fill", o.x-50, o.y-50, 100, 100)
  end
  
end

function love.keypressed(key, scancode, isrepeat)
  if key == "space" then
    
    local hue = math.random() > .5
    local params1 = {}
    local params2 = { speed = 1 }
    if hue then
      params1.hue = {255, 100, 255}
      params2.hue = {255, 100, 0}
    else
      params1.color = {255, 255, 255}
      params2.color = {255, 255, 255, 0}
    end
    
    local object = {
      x = -100,
      y = love.graphics.getHeight()*.5,
      speed = {
        x = 1000,
        y = 0
      },
      color = lue
        :newColor() --create new color
        :setColor(params1) --set it to white
        :setColor(params2) --and fade it
    }
    table.insert(objects, object)
    
  end
end