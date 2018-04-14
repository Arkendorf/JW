graphics = require "graphics"
map = require "map"
game = require "game"
reward = require "reward"
mainmenu = require "mainmenu"
pause = require "pause"
local window = require "window"

function love.load()
  graphics.load()
  window.load()

  map.load()
  game.load()
  reward.load()
  mainmenu.load()
  pause.load()

  state = "main"
  oldstate = "main"
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
  elseif state == "pause" then
    pause.update(dt)
  end
  window.update(dt)
end

function love.draw()
  love.graphics.setCanvas(canvas.game)
  love.graphics.clear()
  if state == "pause" then
    draw(oldstate)
  end
  draw(state)
  love.graphics.setCanvas()
  window.draw()
end

function draw(state)
  if state == "map" then
    map.draw()
  elseif state == "game" then
    game.draw()
  elseif state == "reward" then
    reward.draw()
  elseif state == "main" then
    mainmenu.draw()
  elseif state == "pause" then
    pause.draw()
  end
end

function love.keypressed(key)
  if state == "map" then
    map.keypressed(key)
  elseif state == "reward" then
    reward.keypressed(key)
  elseif state == "main" then
    mainmenu.keypressed(key)
  elseif state == "pause" then
    pause.keypressed(key)
  end
  if key == "escape" and state ~= "pause" and state ~= "main" then
    oldstate = state
    state = "pause"
    pause.start()
  end
end

function love.quit()
  mainmenu.save_game()
  mainmenu.score()
  if char.hp <= 0 then
    mainmenu.game_over()
  end
end
