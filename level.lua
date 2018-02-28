local level = {}

level.load = function()
  level_score = {max = 12, current = 0}
  scroll = {goal = 4000, pos = 0, v = 0}

  backgroundImg = love.graphics.newImage("background.png")
end

level.update = function(dt)
  -- recalculate level difficulty score
  level_score.current = 0
  local enemy_num = 0
  for i, v in pairs(enemies) do
    level_score.current = level_score.current + enemy_info[v.type].score
    enemy_num = enemy_num + 1
  end
  level_score.current = level_score.current * enemy_num -- the more enemies, the more difficult

  -- add new enemy if necessary
  if level_score.current < level_score.max then
    local price = level_score.max - level_score.current -- find max spendable points to reach difficulty
    for i, v in pairs(enemy_info) do -- pick an enemy
      if v.score * enemy_num <= price and math.random(0, 60) == 0 then -- add randomness to limit massive spawn chunks
        enemy.new(i)
      end
    end
  end

  -- do scrolling thing
  if scroll.pos >= scroll.goal then
    enemies = {}
  else
    scroll.v = scroll.v + dt * 60 * 0.2
  end
  scroll.pos = scroll.pos + scroll.v
  scroll.v = scroll.v * 0.9
end

level.draw = function()
  -- temporary background
  love.graphics.draw(backgroundImg, 0, scroll.pos % 400 - 400)
  love.graphics.draw(backgroundImg, 0, scroll.pos % 400)
  love.graphics.draw(backgroundImg, 0, scroll.pos % 400 + 400)

  love.graphics.draw(backgroundImg, 400, scroll.pos % 400 - 400)
  love.graphics.draw(backgroundImg, 400, scroll.pos % 400)
  love.graphics.draw(backgroundImg, 400, scroll.pos % 400 + 400)

  -- info
  love.graphics.print("Ammo: "..tostring(char.ammo).."\nHealth: "..tostring(char.hp).."\nDistance: "..tostring(scroll.pos))
end

return level
