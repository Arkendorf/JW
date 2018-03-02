vector = require "vector"
character = require "character"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"
drop = require "drop"
level = require "level"

love.load = function()
  math.randomseed(os.time())

  love.window.setMode(1200, 800)
  screen = {w = 600, h = 400}
  screen.scale = love.graphics.getWidth()/screen.w

  character.load()

  bullet.load()

  enemy.load()

  drop.load()

  level.load()

  love.graphics.setDefaultFilter("nearest", "nearest")

  canvas = love.graphics.newCanvas(screen.w, screen.h)
end

love.update = function(dt)
  character.update(dt)

  bullet.update(dt)

  enemy.update(dt)

  drop.update(dt)

  level.update(dt)
end

love.draw = function()
  love.graphics.setCanvas(canvas)

  level.draw()

  character.draw()

  bullet.draw()

  enemy.draw()

  drop.draw()

  love.graphics.setCanvas()

  love.graphics.draw(canvas, 0, 0, 0, screen.scale, screen.scale)
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end
