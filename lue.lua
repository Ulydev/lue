-- lue.lua v0.1

-- Copyright (c) 2016 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local lue, lueObject = {
  hue = 0,
  intensity = 0,
  speed = 50,
  c = {}
}, {}

setmetatable(lue, lue)

--[[ Private ]]--

local function lerp(a, b, k) --smooth transitions
  if a == b then
    return a
  else
    if math.abs(a-b) < 0.005 then return b else return a * (1-k) + b * k end
  end
end

local function HSL(h, s, l, a) --where the magic happens
  if s<=0 then return l,l,l,a end
  h, s, l = (h%255)/256*6, s/255, l/255
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return {(r+m)*255, (g+m)*255, (b+m)*255, a}
end

--[[ Public ]]--

function lue:update(dt)
  
  self.hue = self.hue + self.speed * dt
  if self.hue > 255 then
    self.hue = self.hue - 255
  elseif self.hue < 0 then
    self.hue = self.hue + 255
  end
  
  for k, v in pairs(self.c) do
    v:update(dt)
  end

end

function lueObject:update(dt)
  
  if self.target then
    local type, target = self.target.type, self.target.color
    if type == "hue" then
      target = lue:getHueColor(unpack(target))
    end
    for i = 1, 4 do
      self.color[i] = lerp(self.color[i] or 255, target[i] or 255, self.speed * dt)
    end
  elseif self.hue then
    self.color = lue:getHueColor(unpack(self.hue))
  end
  
end

--

function lue:initColor(name, f)
  
  if not self.c[name] then self.c[name] = lue:newColor(f) end
  
end

function lue:newColor(f)
  
  local _object = {}
  
  setmetatable(_object, { __index = lueObject })
  
  return _object
end

function lue:setColor(name, f)
  
  self:initColor(name)
  
  return self.c[name]:setColor(f)
  
end

function lueObject:setColor(f)
  
  if not (f.color or f.speed or f.hue) then f = { color = f } end --mind blown
  
  f.speed = f.speed and (f.speed == true and 1 or f.speed) or false
  
  if f.speed and self.color then
    self.target = { type = f.hue and "hue" or "color", color = f.color or f.hue }
    self.speed = f.speed
  else
    self.color = f.color or lue:getHueColor(unpack(f.hue))
    if f.hue then self.hue = f.hue end
  end
  
  return self
  
end

function lue:getColor(name, target)
  
  return self.c[name] and self.c[name]:getColor(target) or false
  
end

function lueObject:getColor(target)
  
  local color = ((target and self.target) and self.target or self.color)
  return color and {color[1], color[2], color[3], color[4] or 255} or false
  
end

--

function lue:setHueIntensity(intensity)
  self.intensity = intensity
  return self
end

function lue:setHueSpeed(speed)
  self.speed = speed
  return self
end

--

function lue:getHueColor(s, l, a, offset)
  local _s, _l = math.min(math.max(0, s+self.intensity), 255), math.min(math.max(0, l+self.intensity), 255)
  return HSL(self.hue + (offset or 0), _s, _l, a)
end

function lue:getHueIntensity() return self.intensity end

function lue:getHueSpeed() return self.speed end

function lue:getHue() return self.hue end

--[[ End ]]--

return lue