local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "crosser"
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.p.y = math.random(0, screen.h)

  v.a.x = v.info.dir
end

ai.load[2] = function(i, v) -- "fly"
  v.p.x = math.random(0, screen.w)
  v.p.y = -v.r

  v.info.angle = -math.pi*1.5
  v.info.dir = math.random(0, 1)*2-1
end

ai.move = {}

ai.move[1] = function(i, v, dt) -- "crosser"
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed
end

ai.move[2] = function(i, v, dt) -- "fly"
  v.info.angle = v.info.angle + math.rad(dt * 60 * 0.4) * v.info.dir * enemy_info[v.type].speed -- adjust angle
  if v.info.dir == 1 and v.info.angle >= -math.pi then -- change direction
    v.info.dir = -1
  elseif v.info.dir == -1 and v.info.angle <= -math.pi*2 then
    v.info.dir = 1
  end

  v.d.x = math.cos(v.info.angle)
  v.d.y = math.sin(v.info.angle)

  v.a = v.d
end

ai.attack = {}

ai.attack[1] = function(i, v, dt) -- "forward"
  bullet.new("basic", v.p, vector.sum(v.a, vector.scale(0.1, v.d)), 2) -- direction is combo of char's direction and movement

end

ai.attack[2] = function(i, v, dt) -- "aimer"
  bullet.new("basic", v.p, vector.norm(vector.sub(char.p, v.p)), 2)
end

return ai
