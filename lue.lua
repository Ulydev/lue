-- lue.lua v0.1

-- Copyright (c) 2015 Ulysse Ramage
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

local lue = {
  hue = 0,
  intensity = 0,
  speed = 50
}
setmetatable(lue, lue)

--[[ Private ]]--

function lue:HSL(h, s, l, a) --where the magic happens
  if s<=0 then return l,l,l,a end
  h, s, l = h/256*6, s/255, l/255
  local c = (1-math.abs(2*l-1))*s
  local x = (1-math.abs(h%2-1))*c
  local m,r,g,b = (l-.5*c), 0,0,0
  if h < 1     then r,g,b = c,x,0
  elseif h < 2 then r,g,b = x,c,0
  elseif h < 3 then r,g,b = 0,c,x
  elseif h < 4 then r,g,b = 0,x,c
  elseif h < 5 then r,g,b = x,0,c
  else              r,g,b = c,0,x
  end return (r+m)*255, (g+m)*255, (b+m)*255, a
end

--[[ Public ]]--

function lue:update(dt)
  
  self.hue = self.hue + self.speed * dt
  if self.hue > 255 then
    self.hue = self.hue - 255
  elseif self.hue < 0 then
    self.hue = self.hue + 255
  end

end

--

function lue:setIntensity(intensity)
  self.intensity = intensity
  return self
end

function lue:setSpeed(speed)
  self.speed = speed
  return self
end

--

function lue:getColor(s, l, a)
  local _s, _l = math.min(math.max(0, s+self.intensity), 255), math.min(math.max(0, l+self.intensity), 255)
  return self:HSL(self.hue, _s, _l, a)
end

function lue:getIntensity() return self.intensity end

function lue:getSpeed() return self.speed end

function lue:getHue() return self.hue end

--[[ End ]]--

return lue