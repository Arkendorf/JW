local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "crosser"
  -- find direction
  if v.info.dir == nil then
    if v.p.x < screen.w/2 then
      v.info.dir = 1
    else
      v.info.dir = -1
    end
  end

  -- set angle
  v.a.x = .7 * v.info.dir
  v.a.y = -.7
end

ai.move = {}

ai.move[1] = function(i, v, dt) -- "crosser"
  v.d.x = v.info.dir * dt * 60 * 2
end

ai.attack = {}
ai.attack[1] = function(i, v, dt) -- "crosser"
  bullet.new("basic", v.p, v.a, 2)
end

return ai
