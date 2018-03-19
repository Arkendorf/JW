local ai = require "bullet_ai"

local bullet = {}

bullet.load = function()
  bullets = {}
  bullet_info = {}
  bullet_info.basic = {ai = {1, 1}, speed = 6, dmg = 1, r = 4}
end

bullet.update = function(dt)
  for i, v in pairs(bullets) do
    -- update per bullet ai
    ai.update[bullet_info[v.type].ai[2]](i, v, dt)

    -- do damage
    if v.side == 1 then -- check for collision with enemies
      for j, w in pairs(enemies) do
        if collision.overlap(v, w) then
          w.hp = w.hp - bullet_info[v.type].dmg
          bullets[i] = nil
        end
      end
    else -- check for collision with player
      if collision.overlap(v, char) then
        if char.inv <= 0 then
          char.hp = char.hp - 1
        end
        bullets[i] = nil
        char.inv = char_info.inv_time
      end
    end
  end
end

bullet.draw = function()
  for i, v in pairs(bullets) do
    love.graphics.circle("line", v.p.x, v.p.y, v.r, 8)
  end
end

bullet.new = function(type, p, d, side)
  local spot = opening(bullets)
  local info = bullet_info[type]
  bullets[spot] = {type = type, p = p, d = d, r = info.r, side = side}
  -- perform first-time setup
  ai.load[info.ai[1]](spot, bullets[spot])
end

return bullet