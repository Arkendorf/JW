graphics = require "graphics"
map = require "map"
game = require "game"
reward = require "reward"
mainmenu = require "mainmenu"
pause = require "pause"
over = require "over"
window = require "window"
textbox = require "textbox"
tutorial = require "tutorial"

function love.load()
  graphics.load()
  window.load()
  level.load()

  map.load()
  game.load()
  reward.load()
  mainmenu.load()
  pause.load()
  over.load()
  textbox.load()

  state = "main"
  oldstate = "main"
  freeze = false

  palette = {red = {204, 40, 40}, navy = {64, 51, 102}, blue = {0, 132, 204}, green = {122, 204, 40}, colorbase = {190, 183, 204}, brown = {102, 70, 24}, grey = {138, 144, 153}}
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
  elseif state == "over" then
    over.update(dt)
  elseif state == "textbox" then
    textbox.update(dt)
  end
  if tutorial.active and not freeze then
    tutorial.update(dt)
  end
  window.update(dt)
end

function love.draw()
  if freeze == true then
    draw(oldstate)
  end
  draw(state)
  window.draw()

  love.graphics.setCanvas(canvas.game, canvas.menu)
  love.graphics.clear()
  love.graphics.setCanvas()
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
  elseif state == "over" then
    over.draw()
  elseif state == "textbox" then
    textbox.draw()
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
  elseif state == "over" then
    over.keypressed(key)
  elseif state == "textbox" then
    textbox.keypressed(key)
  end
  if key == "escape" and state ~= "pause" and state ~= "main" and state ~= "over" then
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
