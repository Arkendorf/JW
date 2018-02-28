vector = require "vector"
character = require "character"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"
drop = require "drop"
level = require "level"

love.load = function()
  math.randomseed(os.time())

  screen = {w = love.graphics.getWidth(), h = love.graphics.getHeight()}

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
  level.draw()
  
  character.draw()

  bullet.draw()

  enemy.draw()

  drop.draw()
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end
