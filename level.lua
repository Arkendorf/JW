local level = {}

local level_score = {max = 0, current = 0}
local level_reward = 0
local airship = {frame = 1}
local clear = false

local cut_dist = 3

level.scroll = {goal = 0, pos = 0, v = 0}

level.load = function()
end

level.update = function(dt)
  -- recalculate level difficulty score
  if level.scroll.pos > 0 and level.scroll.pos < level.scroll.goal then -- no enemies in intro/outro
    level_score.current = 0
    local enemy_num = 0
    for i, v in pairs(enemies) do
      level_score.current = level_score.current + enemy_info[v.type].score * v.tier
      enemy_num = enemy_num + 1
    end
    level_score.current = level_score.current * enemy_num -- the more enemies, the more difficult

    -- add new enemy if necessary
    if level_score.current < level_score.max then
      local price = level_score.max - level_score.current -- find max spendable points to reach difficulty
      for i, v in pairs(enemy_info) do -- pick an enemy
        if v.score * enemy_num <= price and math.random(0, 4) == 4 then -- pick enemy type
          local tier_price = price - v.score * enemy_num
          for j, w in ipairs(tiers) do
            if v.score * (j-1) < tier_price and math.random(0, 4) == 4 then -- pick enemy tier
              enemy.new(i, j)
            end
          end
        end
      end
    end
    clear = false
  elseif clear == false then
    enemies = {}
    bullets = {}
    particles = {}
    clear = true
  end

  -- do scrolling thing
  if level.scroll.pos >= level.scroll.goal+cut_dist then
    state = "reward"
    reward.start(level_reward, stats)
  else
    level.scroll.v = level.scroll.v + dt * 60 * 0.002
  end
  level.scroll.pos = level.scroll.pos + level.scroll.v
  b_offset = b_offset + level.scroll.v * 100 -- background offset

  level.scroll.v = level.scroll.v * 0.9

  -- animate airship
  airship.frame = airship.frame + dt * 60
  if airship.frame >= 9 then
    airship.frame = 1
  end
end

level.start = function(dif, dist, reward)
  char.p.x = screen.w/2
  char.p.y = screen.h/2
  char.a.x = 0
  char.a.y = -1

  stats = {kills = 0, shots = 0, hits = 0, dmg = 0}

  -- set up level
  level_score.max = dif
  level.scroll = {goal = dist, pos = -cut_dist, v = 0}

  -- reset stuff
  enemies = {}
  bullets = {}
  drops = {}

  -- reset seed
  math.randomseed(os.time())

  level_reward = reward
end

level.draw = function()
  --  ending ship
  level.draw_airship(screen.w/2, screen.h/2+(level.scroll.pos-level.scroll.goal-cut_dist)*100)

  -- starting shio
  level.draw_airship(screen.w/2, screen.h/2+(level.scroll.pos+cut_dist)*100)
end

level.draw_background = function()
  -- background level stuff
  level.draw_airship(screen.w/2, screen.h/2)
  love.graphics.draw(shipimg.char, shipquad.char[1], screen.w/2, screen.h/2, -math.pi/2, 1, 1, 16, 16)
end

level.draw_airship = function(x, y)
  love.graphics.draw(img.airship, x-96, y-108)
  love.graphics.draw(img.propellor, quad.propellor[math.floor(airship.frame)], x+28-17-96, y+52-17-108)
  love.graphics.draw(img.propellor, quad.propellor[math.floor(airship.frame)], x+164-17-96, y+52-17-108)
  love.graphics.draw(img.propellor, quad.propellor[math.floor(airship.frame)], x+25-17-96, y+159-17-108)
  love.graphics.draw(img.propellor, quad.propellor[math.floor(airship.frame)], x+167-17-96, y+159-17-108)
end

return level
