lue
==============

lue is a LÖVE library that allows you to manage your colors and display hue effects in your game.

![swotch][swotch]

See [HSL](https://en.wikipedia.org/wiki/HSL_and_HSV)

Setup
----------------

```lua
local lue = require "lue" --require the library
```

Usage
----------------

Set color
```lua
function love.load()
  lue:setColor("my-color", {255, 255, 255})
end
```

Update lue
```lua
function love.update(dt)
  lue:update(dt)
end
```

Get color
```lua
function love.draw()
  love.graphics.setColor( lue:getColor("my-color") )
end
```

Color objects
----------------

You might also declare color objects instead of calling lue:setColor("colorname", color)

For instance,
```lua
function love.load()
  myColor = lue:newColor():setColor({255, 255, 255}) --methods can be chained
end

function love.update(dt)
  myColor:update(dt)
end

function love.draw()
  love.graphics.setColor( myColor:getColor() )
end
```

Methods
----------------

Update lue
```lua
lue:update(dt)
```

Set color
```lua
lue:setColor("name", {colorTable}) --basic
lue:setColor("name", {

  color = colorTable,
  --[[ or ]]--
  hue = hueTable -- {saturation, lightness, opacity, offset}
  
  
  
  speed = number, --if provided, color with transition smoothly
  
})

--the same goes for myColor:setColor(...), just remove the "name" argument
```

Get color - if target == true, then the function will return the target color instead of the current color
```lua
lue:getColor("name", target)
myColor:getColor(target)
```

Get hue color - offset defaults to 0
```lua
lue:getHueColor(saturation, lightness, opacity, offset)
```
All values range from **0** to **255**.

Set/get the global color intensity of lue - useful for spontaneous color effects such as explosions
```lua
lue:setIntensity(intensity)
lue:getIntensity()
```

Set/get hue speed
```lua
lue:setSpeed(speed)
lue:getSpeed()
```

Get the current hue value (0-255)
```lua
lue:getHue()
```

[swotch]: https://media.giphy.com/media/l4HnRFyvYjzzutu2Q/giphy.gif
