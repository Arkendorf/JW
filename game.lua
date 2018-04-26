vector = require "vector"
character = require "character"
enemy = require "enemy"
bullet = require "bullet"
collision = require "collision"
drop = require "drop"
level = require "level"
particle = require "particle"

local game = {}

tiers = {}
tiers[1] = {color = {205, 100, 25}}
tiers[2] = {color = {255, 50, 50}}
tiers[3] = {color = {255, 50, 150}}
tiers[4] = {color = {50, 185, 0}}
tiers[5] = {color = {255, 235, 235}}
tiers[6] = {color = {75, 75, 75}}

game.load = function()

  character.load()

  bullet.load()

  enemy.load()

  drop.load()

  level.load()

  particle.load()
end

game.update = function(dt)
  character.update(dt)

  bullet.update(dt)

  enemy.update(dt)

  drop.update(dt)

  level.update(dt)

  particle.update(dt)
end

game.draw = function()
  love.graphics.setCanvas(canvas.game)
  level.draw()

  drop.draw()

  particle.draw()

  bullet.draw()

  enemy.draw()

  character.draw()
  love.graphics.setCanvas()
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
