local level = {}

local level_score = {max = 0, current = 0}
local scroll = {goal = 4000, pos = 0, v = 0}

level.load = function()
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
    state = "map"
  else
    scroll.v = scroll.v + dt * 60 * 0.2
  end
  scroll.pos = scroll.pos + scroll.v
  scroll.v = scroll.v * 0.9
end

level.draw = function()
  -- temporary background
  for i = -math.ceil(screen.h/400/2), math.ceil(screen.h/400/2) do
    love.graphics.draw(img.background, 0, math.floor(scroll.pos % 400) + i*400)
  end

  -- info
  love.graphics.print("Ammo: "..tostring(char.ammo).."\nHealth: "..tostring(char.hp).."\nDistance: "..tostring(scroll.pos))
end

level.start = function(dif, dist, reward)
  -- set up level
  level_score.max = dif
  scroll = {goal = dist*100, pos = 0, v = 0}

  -- reset stuff
  enemies = {}
  bullets = {}

  -- reset seed
  math.randomseed(os.time())
end

return level