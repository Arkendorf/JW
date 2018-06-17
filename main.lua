graphics = require "graphics"
map = require "map"
game = require "game"
reward = require "reward"
manage = require "manage"
window = require "window"
textbox = require "textbox"
tutorial = require "tutorial"
menu = require "menu"

function love.load()
  state = "reward"
  oldstate = "menu"
  freeze = false
  save = false

  palette = {red = {204, 40, 40}, navy = {64, 51, 102}, blue = {0, 132, 204}, green = {122, 204, 40}, colorbase = {190, 183, 204}, brown = {102, 70, 24}, grey = {138, 144, 153}, dark_blue = {64, 51, 102}}

  graphics.load()
  window.load()
  level.load()

  map.load()
  game.load()
  reward.load()
  manage.load()
  textbox.load()
  menu.load()

  manage.load_settings()

  menu.start_main()
end

function love.update(dt)
  if state == "map" then
    map.update(dt)
  elseif state == "game" then
    game.update(dt)
  elseif state == "reward" then
    reward.update(dt)
  elseif state == "menu" then
    menu.update(dt)
  elseif state == "textbox" then
    textbox.update(dt)
  end
  if tutorial.active and not freeze then
    tutorial.update(dt)
  end
  window.update(dt)
end

function love.draw()
  if freeze then
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
  elseif state == "menu" then
    menu.draw()
  elseif state == "textbox" then
    textbox.draw()
  end
end

function love.keypressed(key)
  if state == "map" then
    map.keypressed(key)
  elseif state == "reward" then
    reward.keypressed(key)
  elseif state == "menu" then
    menu.keypressed(key)
  elseif state == "textbox" then
    textbox.keypressed(key)
  end
  if key == "escape" and state ~= "menu" then
    if state ~= "textbox" then
      oldstate = state
    end
    menu.start_pause()
  elseif key == "escape" and state == "menu" and freeze then
    menu.end_pause()
  end
end

function love.quit()
  if save then
    manage.save_game()
  end
  manage.save_settings()
  manage.score()
  if char.hp <= 0 then
    manage.game_over()
  end
end
