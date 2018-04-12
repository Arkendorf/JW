graphics = require "graphics"
map = require "map"
game = require "game"
reward = require "reward"
mainmenu = require "mainmenu"
local window = require "window"

function love.load()
  graphics.load()
  window.load()

  map.load()
  game.load()
  reward.load()
  mainmenu.load()

  state = "main"

  money = 0
end

function love.update(dt)
  if state == "map" then
    map.update(dt)
  elseif state == "game" then
    game.update(dt)
  elseif state == "reward" then
    reward.update(dt)
  elseif state == "main" then
    mainmenu.update(dt)
  end
  window.update(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas.game)
  love.graphics.clear()
  if state == "map" then
    map.draw()
  elseif state == "game" then
    game.draw()
  elseif state == "reward" then
    reward.draw()
  elseif state == "main" then
    mainmenu.draw()
  end
  love.graphics.setCanvas()

  window.draw()
end

function love.keypressed(key)
  if state == "map" then
    map.keypressed(key)
  elseif state == "reward" then
    reward.keypressed(key)
  elseif state == "main" then
    mainmenu.keypressed(key)
  end
  if key == "escape" then
    mainmenu.save_game()
    mainmenu.score()
    love.event.quit()
  end
end
