local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  v.p = vector.sum(v.p, vector.scale(bullet_info[v.type].speed * dt * 60, v.d))

  -- check if bullet is off screen
  if v.p.x < 0 or v.p.x > screen.w or v.p.y < 0 or v.p.y > screen.h then
    bullets[i] = nil
  end
end

return ai
