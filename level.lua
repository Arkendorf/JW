local level = {}

local level_score = {max = 0, current = 0}
local level_reward = 0

level.scroll = {goal = 0, pos = 0, v = 0}

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
  if level.scroll.pos >= level.scroll.goal then
    state = "reward"
    reward.start(level_reward, stats)
  else
    level.scroll.v = level.scroll.v + dt * 60 * 0.002
  end
  level.scroll.pos = level.scroll.pos + level.scroll.v
  b_offset = b_offset + level.scroll.v * 100 -- background offset

  level.scroll.v = level.scroll.v * 0.9
end

level.start = function(dif, dist, reward)
  char.x = 200
  char.y = 300

  stats = {kills = 0, shots = 0, hits = 0, dmg = 0}

  -- set up level
  level_score.max = dif
  level.scroll = {goal = dist, pos = 0, v = 0}

  -- reset stuff
  enemies = {}
  bullets = {}
  drops = {}

  -- reset seed
  math.randomseed(os.time())

  level_reward = reward
end

return level
