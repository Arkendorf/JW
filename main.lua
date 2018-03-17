local graphics = require "graphics"
local map = require "map"
local game = require "game"

function love.load()
  graphics.load()
  map.load()
  game.load()

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
end

function love.keypressed(key)
  if state == "map" then
    map.keypressed(key)
  end
end
