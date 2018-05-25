local drop = {}

drop.load = function()
  drops = {}
end

drop.update = function(dt)
  for i, v in pairs(drops) do
    v.p = vector.sum(v.p, vector.scale(8 * dt * 60, v.d))
    v.d = vector.scale(0.8, v.d)
    if bossfight.active == true or bossfight.pause > 0 then
      v.p.y = v.p.y + dt * 16
    else
      v.p.y = v.p.y + dt * 32
    end
    if v.p.y > screen.h+16 then
      drops[i] = nil -- remove drop
    end

    -- increase variable if picked up
    if collision.overlap(char, v, 4) then
      local pickup = false
      if v.type == 1 and char.hp < char_info.hp_max then -- hp
        if char.hp+v.num < char_info.hp_max then -- if new quantity is under max, set quantity to new quantity
          char.hp = char.hp + v.num
        else -- if new quantity is over max, set it to max
          char.hp = char_info.hp_max
        end
        pickup = true
      elseif v.type == 2 and char.ammo < char_info.ammo_max then -- ammo
        if char.ammo+v.num < char_info.ammo_max then -- if new quantity is under max, set quantity to new quantity
          char.ammo = char.ammo + v.num
        else -- if new quantity is over max, set it to max
          char.ammo = char_info.ammo_max
        end
        pickup = true
      elseif v.type == 3 then -- money
        money = money + v.num
        pickup = true
      end
      if pickup then
        particle.new("pop", v.p, {x = 0, y = 0}, {x = 0, y = 0})
        drops[i] = nil -- remove drop
      end
    end
  end

  -- random drops
  if math.random(0, 1200) == 0 then
    if math.random(0, 1) == 0 then
      drop.new(2, {x = math.random(32, screen.w-64), y = -8}, math.random(4, 8), false) -- ammo
    else
      drop.new(1, {x = math.random(32, screen.w-64), y = -8}, 1, false) -- hp
    end
  end
end

drop.draw = function()
  for i, v in pairs(drops) do
    love.graphics.draw(img.drops, quad.drops[v.type], math.floor(v.p.x), math.floor(v.p.y), 0, 1, 1, 16, 16)
  end
end

drop.new = function(type, p, num, burst)
  local d = {}
  if burst then
    d = {x = math.random(-100, 100)/100, y = math.random(-100, 100)/100}
  else
    d = {x = 0, y = 0}
  end
  drops[opening(drops)] = {type = type, p = p, d = d, r = 4, num = num}
end

return drop
