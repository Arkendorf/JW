vector = require "vector"
character = require "character"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"
drop = require "drop"
level = require "level"

love.graphics.setDefaultFilter("nearest", "nearest")

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
end

love.update = function(dt)
  character.update(dt)

  bullet.update(dt)

  enemy.update(dt)

  drop.update(dt)

  level.update(dt)
end

love.draw = function()
  love.graphics.push()
  love.graphics.scale(screen.scale, screen.scale)

  level.draw()

  character.draw()

  bullet.draw()

  enemy.draw()

  drop.draw()

  love.graphics.pop()
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end
