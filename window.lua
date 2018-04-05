local window = {}

local hud = require "hud"

window.load = function()
  -- set up window
  screen = {w = 600, h = 400}
  local w, h = love.window.getDesktopDimensions()
  if screen.w/screen.h < w/h then
    screen.scale = h/screen.h
  else
    screen.scale = w/screen.w
  end
  screen.ox = math.floor((w/screen.scale - screen.w) / 2)
  screen.oy = math.floor((h/screen.scale - screen.h) / 2)
  love.window.setFullscreen(true)
  --love.window.setMode(w, h-12)

  canvas.game = love.graphics.newCanvas(screen.w, screen.h)
  canvas.window = love.graphics.newCanvas(w/screen.scale, h/screen.scale)

  b_offset = 0
end

window.draw = function()
  love.graphics.setCanvas(canvas.window)
  love.graphics.clear()

  -- draw background
  for i = -math.ceil(screen.h/600/2), math.ceil(screen.h/600/2) do
    love.graphics.draw(img.background, screen.ox, math.floor((b_offset/2) % 600) + i*600)
  end

  -- draw game
  love.graphics.draw(canvas.game, screen.ox, screen.oy)

  -- draw borders
  for i = -math.ceil(screen.h/400/2), math.ceil(screen.h/400/2) do
    love.graphics.draw(img.clouds, math.floor(screen.ox-600), math.floor(b_offset % 400) + i*400)
    love.graphics.draw(img.clouds, math.floor(screen.ox+screen.w+600), math.floor(b_offset % 400) + i*400, 0, -1, 1)
  end

  hud.draw()

  love.graphics.setCanvas()

  love.graphics.draw(canvas.window, 0, 0, 0, screen.scale, screen.scale)
end

return window
