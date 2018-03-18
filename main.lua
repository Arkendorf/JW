local graphics = require "graphics"
local map = require "map"
local game = require "game"

function love.load()
  -- set up window
  screen = {w = 600, h = 400}
  local w, h = love.window.getDesktopDimensions()
  if screen.w/screen.h < w/h then
    screen.scale = h/screen.h
  else
    screen.scale = w/screen.w
  end
  screen.ox = math.floor((w - screen.w*screen.scale) / 2)
  screen.oy = math.floor((h - screen.h*screen.scale) / 2)
  love.window.setFullscreen(true)

  graphics.load()
  map.load()
  game.load()

  canvas.window = love.graphics.newCanvas(screen.w, screen.h)

  state = "map"
end

function love.update(dt)
  if state == "map" then
    map.update(dt)
  elseif state == "game" then
    game.update(dt)
  end
end

function love.draw()
  if state == "map" then
    map.draw()
  elseif state == "game" then
    game.draw()
  end
  love.graphics.draw(canvas.window, screen.ox, screen.oy, 0, screen.scale, screen.scale)
  love.graphics.draw(img.clouds, math.floor(screen.ox-432*screen.scale), 0, 0, screen.scale, screen.scale)
  love.graphics.draw(img.clouds, math.floor(screen.ox+(screen.w+432)*screen.scale), 0, 0, -screen.scale, screen.scale)
end

function love.keypressed(key)
  if state == "map" then
    map.keypressed(key)
  end
  if key == "escape" then
    love.event.quit()
  end
end
