local ai = {}

ai.load = {}

ai.load.cross = function(i, v)
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.p.y = math.random(v.r, screen.h-v.r)

  v.a.x = v.info.dir
end

ai.load.turn = function(i, v)
  v.p.x = math.random(0, screen.w)
  v.p.y = -v.r

  v.info.angle = math.pi*.5
  v.info.dir = math.random(0, 1)*2-1
end

ai.load.sine = function(i, v)
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.info.t = 0
  v.info.y = math.random(v.r, screen.h-v.r)

  v.a.x = v.info.dir
end

ai.load.circle = function(i, v) -- "circler"
  v.p.x = screen.w/2
  v.p.y = -v.r
  v.a = {x = 0, y = 1}

  v.info.angle = -math.pi/2
  v.info.r = 160
  v.info.dir = 1

  v.info.shots = 0
  v.info.hp = v.hp

  v.info.alt = true
end

ai.load.point = function(i, v) -- pick-a-point
  v.p.x = math.random(v.r, screen.w-v.r)
  v.p.y = screen.h+v.r

  v.info.x = math.random(screen.w*.1+v.r, screen.w*.9-v.r)
  v.info.y = math.random(screen.h*.1+v.r, screen.h*.9-v.r)

  v.a.x = 0
  v.a.y = 1

  v.info.angle = math.atan2(v.info.y-v.p.y, v.info.x-v.p.x)
end


ai.move = {}

ai.move.cross = function(i, v, dt) -- "crosser"
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed
end

ai.move.weave = function(i, v, dt) -- "fly"
  v.info.angle = v.info.angle + math.rad(dt * 60)*enemy_info[v.type].turn_speed * v.info.dir -- adjust angle
  if v.info.dir == 1 and v.info.angle >= math.pi then -- change direction
    v.info.dir = -1
  elseif v.info.dir == -1 and v.info.angle <= 0 then
    v.info.dir = 1
  end

  v.d.x = math.cos(v.info.angle)
  v.d.y = math.sin(v.info.angle)

  v.a = v.d

  v.d = vector.scale(enemy_info[v.type].speed, v.d)
end

ai.move.sine = function(i, v, dt) -- "siner"
  v.info.t = v.info.t + dt
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed
  v.p.y = v.info.y + math.sin(v.info.t * 2) * 32
end

ai.move.follow = function(i, v, dt) -- "follower"
  local turn_speed = math.rad(dt * 60)*enemy_info[v.type].turn_speed
  local goal_angle = math.atan2(char.p.y-v.p.y, char.p.x-v.p.x)
  if goal_angle < 0 then
    goal_angle = goal_angle + math.pi*2
  end
  local dif = goal_angle-v.info.angle
  if dif > (math.pi*2-math.abs(dif))*dif/math.abs(dif) then -- don't even try to understand this nonsense
    if math.abs(dif) < turn_speed or math.pi*2-math.abs(dif) < turn_speed then
      v.info.angle = goal_angle
    else
      v.info.angle = v.info.angle - turn_speed
    end
  else
    if math.abs(dif) < turn_speed or math.pi*2-math.abs(dif) < turn_speed then
      v.info.angle = goal_angle
    else
      v.info.angle = v.info.angle + turn_speed
    end
  end

  -- make angle within range
  if v.info.angle > math.pi*2 then
    v.info.angle = v.info.angle - math.pi*2
  elseif v.info.angle < 0 then
    v.info.angle = v.info.angle + math.pi*2
  end

  v.d.x = math.cos(v.info.angle)
  v.d.y = math.sin(v.info.angle)

  v.a = v.d

  v.d = vector.scale(enemy_info[v.type].speed, v.d)
end

ai.move.bounce = function(i, v, dt) -- "back and forth"
  if v.p.x < screen.w*.1 and v.info.dir == -1 then
    v.info.dir = 1
  elseif v.p.x > screen.w*.9 and v.info.dir == 1 then
    v.info.dir = -1
  end
  v.d.x = v.d.x + v.info.dir * dt * 6 * enemy_info[v.type].speed
end

ai.move.circle = function(i, v, dt) -- "circler"
  if v.hp < v.info.hp then
    v.info.hp = v.hp
    v.info.dir = v.info.dir * -1
  end
  if v.p.y < screen.h/2 - v.info.r then
    v.d.y = dt * 60 * enemy_info[v.type].speed
  else
    v.info.angle = v.info.angle + math.rad(dt * 60) * enemy_info[v.type].speed * v.info.dir
    v.p.x = screen.w/2 + v.info.r * math.cos(v.info.angle)
    v.p.y = screen.h/2 + v.info.r * math.sin(v.info.angle)
  end

  v.a = vector.norm(vector.sub(char.p, v.p))
end

ai.move.point = function(i, v, dt) -- pick-a-point
  if math.abs(enemy.stop_dist(v).y) <= v.p.y-v.info.y then
    v.d.x = enemy_info[v.type].speed * math.cos(v.info.angle)
    v.d.y = enemy_info[v.type].speed * math.sin(v.info.angle)
  end
end

ai.attack = {}

ai.attack.default = function(i, v, dt) -- fire ASAP
  if v.atk <= 0 then
    -- fire bullet
    ai.bullet[enemy_info[v.type].ai[4]](i, v, dt)
    v.atk = enemy_info[v.type].atk_delay
  else
    -- decrease wait till next bullet
    v.atk = v.atk - dt
  end
end

ai.attack.passive = function(i, v, dt) -- don't attack
  v.atk = 1
end

ai.attack.volley = function(i, v, dt) -- fire ASAP with delay
  if v.info.shots > 4 then
    v.atk = enemy_info[v.type].atk_delay * 8
    v.info.shots = 0
  elseif v.atk <= 0 then
    -- fire bullet
    ai.bullet[enemy_info[v.type].ai[4]](i, v, dt)
    v.atk = enemy_info[v.type].atk_delay
    v.info.shots = v.info.shots + 1
  else
    -- decrease wait till next bullet
    v.atk = v.atk - dt
  end
end

ai.bullet = {}

ai.bullet.straight = function(i, v, dt) -- "forward"
  bullet.new(enemy_info[v.type].bullet, v.p, vector.sum(v.a, vector.scale(0.1, v.d)), 2, v.tier, i) -- direction is combo of char's direction and movement
end

ai.bullet.aim = function(i, v, dt) -- "aimer"
  bullet.new(enemy_info[v.type].bullet, v.p, vector.norm(vector.sub(char.p, v.p)), 2, v.tier, i)
end

ai.bullet.double = function(i, v, dt) -- "double forward"
  local angle = math.atan2(v.a.y, v.a.x)
  local bullet_d = {}
  bullet_d[1] = {x = 8*math.cos(angle+math.pi/2), y = 8*math.sin(angle+math.pi/2)}
  bullet_d[2] = {x = 8*math.cos(angle-math.pi/2), y = 8*math.sin(angle-math.pi/2)}
  for j, w in ipairs(bullet_d) do
    bullet.new(enemy_info[v.type].bullet, vector.sum(v.p, w), vector.sum(v.a, vector.scale(0.1, v.d)), 2, v.tier, i) -- direction is combo of char's direction and movement
  end
end

ai.bullet.side = function(i, v, dt) -- "side cannons"
  local angle = math.atan2(v.a.y, v.a.x)
  local bullet_a = {}
  bullet_a[1] = {x = math.cos(angle+math.pi/2), y = math.sin(angle+math.pi/2)}
  bullet_a[2] = {x = math.cos(angle-math.pi/2), y = math.sin(angle-math.pi/2)}
  local bullet_d = {}
  bullet_d[1] = {x = v.a.x*6, y = v.a.y*6}
  bullet_d[2] = {x = v.a.x*-6, y = v.a.y*-6}
  for j, w in ipairs(bullet_d) do
    bullet.new(enemy_info[v.type].bullet, vector.sum(v.p, w), bullet_a[1], 2, v.tier, i)
    bullet.new(enemy_info[v.type].bullet, vector.sum(v.p, w), bullet_a[2], 2, v.tier, i)
  end
end

ai.bullet.quad = function(i, v, dt) -- "el gorious"
  local angle = math.atan2(v.a.y, v.a.x)
  local bullet_d = {}
  local r = 18
  if v.info.alt == true then
    r = 24
    v.info.alt = false
  else
    v.info.alt = true
  end
  bullet_d[1] = {x = r*math.cos(angle+math.pi/2), y = r*math.sin(angle+math.pi/2)}
  bullet_d[2] = {x = r*math.cos(angle-math.pi/2), y = r*math.sin(angle-math.pi/2)}
  for j, w in ipairs(bullet_d) do
    bullet.new(enemy_info[v.type].bullet, vector.sum(v.p, w), vector.sum(v.a, vector.scale(0.1, v.d)), 2, v.tier, i) -- direction is combo of char's direction and movement
  end
end

return ai
