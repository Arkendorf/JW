local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "crosser"
  -- set position and direction
  v.info.dir = math.random(0, 1)*2-1
  v.p.x = screen.w/2-screen.w/2*v.info.dir
  v.p.y = math.random(0, screen.h)

  v.a.x = v.info.dir
end

ai.move = {}

ai.move[1] = function(i, v, dt) -- "crosser"
  v.d.x = v.info.dir * dt * 60 * enemy_info[v.type].speed

  if (v.p.x-screen.w/2)*v.info.dir > screen.w/2 then
    enemies[i] = nil
  end
end

ai.attack = {}

ai.attack[1] = function(i, v, dt) -- "crosser"
  bullet.new("basic", v.p, v.a, 2)
end

ai.attack[2] = function(i, v, dt) -- "aimer"
  bullet.new("basic", v.p, vector.norm(vector.sub(char.p, v.p)), 2)
end

return ai
