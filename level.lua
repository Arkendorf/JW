local level = {}

local level_score = {max = 0, current = 0}
local level_reward = 0
local airship = {frame = 1}
local clear = false

local cut_dist = 3
local spawn_delay = 0
local wave_time = 6

bossfight = {active = false, boss = 0, pause = 0, bar_w = 136, c_bar_w = 0, hud_pos = 0}

level.scroll = {goal = 0, pos = 0, v = 0}

level.load = function()
  canvas.healthbar = love.graphics.newCanvas(200, 64)
end

level.update = function(dt)
  -- recalculate level difficulty score
  if level.scroll.pos > 0 and level.scroll.pos < level.scroll.goal then -- no enemies in intro/outro
    if spawn_delay <= 0 then -- pause between waves
      local num = 1
      local score = 0
      local done = false
      while score < level_score.max and not done do
        local price = level_score.max - score -- find max spendable points to reach difficulty
        local choices = {} -- list of enemies that can be added
        for i, v in pairs(enemy_info) do -- pick an enemy
          if not v.boss and v.score <= level_score.each and v.score * num <= price then -- see if enemy difficulty fits needed difficulty
            choices[#choices + 1] = i -- add to list of options
          end
        end

        if #choices > 0 then
          local choice = choices[math.random(1, #choices)] -- randomly pick suitable enemy
          for tier = tier_max, 1, -1 do -- find maximum tier that still fits difficulty score
            if enemy_info[choice].score * num * tier <= price then
              enemy.new(choice, math.random(1, tier)) -- spawn enemy
              score = score + enemy_info[choice].score * num * tier
              num = num + 1
              break
            end
          end
        else
          done = true
        end
      end
      spawn_delay = wave_time
    else
      spawn_delay = spawn_delay - dt
    end
  end

  -- do scrolling thing
  if level.scroll.pos >= level.scroll.goal+cut_dist then
    state = "reward"
    reward.start(level_reward, stats)
  elseif bossfight.pause > 0 then
    bossfight.pause = bossfight.pause - dt
    if bossfight.pause <= 0 and bossfight.active == true then -- wait before spawning boss
      if bossfight.convo == false then -- dialogue
        textbox.start(enemy_info[bossfight.type].text)
        bossfight.pause = .5
        bossfight.convo = true
      else
        bossfight.boss = enemy.new(bossfight.type, math.random(1, tier_max)) -- spawn random valid boss with random valid tier
      end
    end
  elseif level.scroll.pos >= level.scroll.goal and clear == false then
    for i, v in pairs(enemies) do -- remove enemies (with a bang)
      enemy.explosion(v)
    end
    level.clear(true) -- clear level, except for drops
    if math.random(0, 3) == 0 and not tutorial.active then -- randomly decide to spawn boss
      local boss_options = {}
      for i, v in pairs(enemy_info) do -- find possible bosses
        if v.boss and v.score < level_score.max then
          boss_options[#boss_options+1] = i
        end
      end
      if #boss_options > 0 then -- make sure there is an option
        bossfight.pause = 1
        bossfight.active = true
        bossfight.convo = false

        bossfight.type = boss_options[math.random(1, #boss_options)]
        bossfight.c_bar_w = bossfight.bar_w
      end
    end
  elseif not bossfight.active then
    level.scroll.v = level.scroll.v + dt * 60 * 0.002 -- move through level
  end
  level.scroll.pos = level.scroll.pos + level.scroll.v
  b_offset = b_offset + level.scroll.v -- background offset

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
  level_score.each = 2+math.floor((#map.path-1) / 2)
  level.scroll = {goal = dist, pos = -cut_dist, v = 0}

  tier_max = 1+math.floor((#map.path-1)/tier_score) -- find max tier for weapons/enemies
  if tier_max < 1 then
    tier_max = 1
  elseif tier_max > #tiers then
    tier_max = #tiers
  end

  -- reset stuff
  level.clear()
  particles = {}
  spawn_delay = 0

  clear = false
  bossfight.active = false

  -- reset seed
  math.randomseed(os.time())

  level_reward = reward
end

level.draw = function()
  --  ending ship
  if not bossfight.active and bossfight.pause <= 0 then
    level.draw_airship(screen.w/2, screen.h/2+(level.scroll.pos-level.scroll.goal-cut_dist)*100)
  end

  -- starting ship
  level.draw_airship(screen.w/2, screen.h/2+(level.scroll.pos+cut_dist)*100)
end

level.clear = function(keep_drops)
  enemies = {}
  bullets = {}
  if not keep_drops then
    drops = {}
  end
  clear = true
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
