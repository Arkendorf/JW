local textbox = {}

local on = false
local boxes = {}
local current_box = 1
local pos = {}
local str_len

textbox.load = function()
  pos = {x = math.floor(screen.w-200)/2, y = screen.h}
  canvas.textbox = love.graphics.newCanvas(200, 64)
end

textbox.start = function(table)
  state = "textbox"
  freeze = true
  on = true
  boxes = table
  current_box = 1
  str_len = 1
end

textbox.update = function(dt)
  pos.y = graphics.zoom(not on, pos.y, screen.h-66, screen.h, dt * 12)
  if str_len < string.len(boxes[current_box].text) then
    str_len = str_len + dt * 18
  elseif str_len > string.len(boxes[current_box].text) then
    str_len = string.len(boxes[current_box].text)
  end

  if on == false and math.ceil(pos.y) >= screen.h then
    state = oldstate
    oldstate = ""
  end
end

textbox.draw = function()
  love.graphics.setCanvas(canvas.textbox)
  love.graphics.draw(img.textbox)
  love.graphics.draw(img.charicons, quad.charicons[boxes[current_box].image])
  love.graphics.printf(string.sub(boxes[current_box].text, 1, math.floor(str_len)), 66, 2, 136)

  love.graphics.setCanvas(canvas.menu)
  love.graphics.draw(canvas.textbox, pos.x, pos.y)
end

textbox.keypressed = function(key)
  if key == "z" then
    if str_len < string.len(boxes[current_box].text) then
      str_len = string.len(boxes[current_box].text)
    elseif current_box < #boxes then
      current_box = current_box + 1
      str_len = 1
    else
      on = false
    end
  end
end

return textbox
