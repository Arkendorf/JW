vector = require "vector"
character = require "character"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"
drop = require "drop"
level = require "level"

local game = {}

game.load = function()

  character.load()

  bullet.load()

  enemy.load()

  drop.load()

  level.load()
end

game.update = function(dt)
  character.update(dt)

  bullet.update(dt)

  enemy.update(dt)

  drop.update(dt)

  level.update(dt)
end

game.draw = function()
  --  ending ship
  level.draw_airship(screen.w/2, screen.h/2-level.scroll.goal*100+level.scroll.pos*100)

  -- starting shio
  level.draw_airship(screen.w/2, screen.h/2+level.scroll.pos*100)

  drop.draw()

  bullet.draw()

  character.draw()

  enemy.draw()
end

opening = function(a) -- find available space in list 'a'
  for i, v in ipairs(a) do
    if v == nil then
      return i
    end
  end
  return #a + 1
end

return game
