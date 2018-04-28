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

  v.info.angle = -math.pi*1.5
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
  v.info.angle = v.info.angle + math.rad(dt * 60) * v.info.dir -- adjust angle
  if v.info.dir == 1 and v.info.angle >= -math.pi then -- change direction
    v.info.dir = -1
  elseif v.info.dir == -1 and v.info.angle <= -math.pi*2 then
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

return ai
