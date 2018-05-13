local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "crosser"
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.p.y = math.random(v.r, screen.h-v.r)

  v.a.x = v.info.dir
end

ai.load[2] = function(i, v) -- "fly"
  v.p.x = math.random(0, screen.w)
  v.p.y = -v.r

  v.info.angle = math.pi*.5
  v.info.dir = math.random(0, 1)*2-1
end

ai.load[3] = function(i, v) -- "siner"
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.info.t = 0
  v.info.y = math.random(v.r, screen.h-v.r)

  v.a.x = v.info.dir
end

ai.move = {}

ai.move[1] = function(i, v, dt) -- "crosser"
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed
end

ai.move[2] = function(i, v, dt) -- "fly"
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

ai.move[3] = function(i, v, dt) -- "siner"
  v.info.t = v.info.t + dt
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed
  v.p.y = v.info.y + math.sin(v.info.t * 2) * 32
end

ai.move[4] = function(i, v, dt) -- "follower"
  local turn_speed = math.rad(dt * 60)*enemy_info[v.type].turn_speed
  local goal_angle = math.atan2(char.p.y-v.p.y, char.p.x-v.p.x)
  if v.info.angle > goal_angle then
    if goal_angle - v.info.angle > turn_speed then
      v.info.angle = goal_angle
    else
      v.info.angle = v.info.angle - turn_speed
    end
  else
    if v.info.angle - goal_angle > turn_speed then
      v.info.angle = goal_angle
    else
      v.info.angle = v.info.angle + turn_speed
    end
  end

  v.d.x = math.cos(v.info.angle)
  v.d.y = math.sin(v.info.angle)

  v.a = v.d

  v.d = vector.scale(enemy_info[v.type].speed, v.d)
end


ai.attack = {}

ai.attack[1] = function(i, v, dt) -- fire ASAP
  if v.atk <= 0 then
    -- fire bullet
    ai.bullet[enemy_info[v.type].ai[4]](i, v, dt)
    v.atk = enemy_info[v.type].atk_delay
  else
    -- decrease wait till next bullet
    v.atk = v.atk - dt
  end
end

ai.bullet = {}

ai.bullet[1] = function(i, v, dt) -- "forward"
  bullet.new("basic", v.p, vector.sum(v.a, vector.scale(0.1, v.d)), 2, v.tier) -- direction is combo of char's direction and movement
end

ai.bullet[2] = function(i, v, dt) -- "aimer"
  bullet.new("basic", v.p, vector.norm(vector.sub(char.p, v.p)), 2, v.tier)
end

ai.bullet[3] = function(i, v, dt) -- "double forward"
  local angle = math.atan2(v.a.y, v.p.y)
  local bullet_d = {}
  bullet_d[1] = {x = 8*math.cos(angle+math.pi/2), y = 8*math.sin(angle+math.pi/2)}
  bullet_d[2] = {x = 8*math.cos(angle-math.pi/2), y = 8*math.sin(angle-math.pi/2)}
  for j, w in ipairs(bullet_d) do
    bullet.new("basic", vector.sum(v.p, w), vector.sum(v.a, vector.scale(0.1, v.d)), 2, v.tier) -- direction is combo of char's direction and movement
  end
end

return ai
