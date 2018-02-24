local enemy = {}

enemy.load = function()
  enemies = {}
  enemy.new("crosser", 0, 100)
end

enemy.update = function(dt)
  for i, v in pairs(enemies) do
    if v.type == "crosser" then
      -- find direction if it's not set
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

      -- move
      v.d.x = v.info.dir * dt * 60 * 2
    end

    -- do basics
    v.p = vector.sum(v.p, v.d)
    v.d = vector.scale(.9, v.d)

    if v.hp <= 0 then
      enemies[i] = nil
    end
  end
end

enemy.draw = function()
  for i, v in pairs(enemies) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 32)
    love.graphics.line(v.p.x, v.p.y, v.p.x+v.a.x*v.r, v.p.y+v.a.y*v.r)
  end
end

enemy.new = function(type, x, y) -- add enemy to open space in list
  enemies[opening(enemies)] = {p = {x = x, y = y}, d = {x = 0, y = 0}, a = {x = 1, y = 0}, r = 16, hp = 4, type = type, info = {}}
end

return enemy
