local hud = {}

local hud_pos = -184

hud.update = function(dt)
  if state ~= "pause" then
    hud_pos = graphics.zoom(state ~= "main", hud_pos, -184, 4+screen.ox, dt * 12)
  else
    hud_pos = graphics.zoom(oldstate ~= "main", hud_pos, -184, 4+screen.ox, dt * 12)
  end

  if bossfight.active and bossfight.pause <= 0 then
    local hp_max = enemy_info[bossfight.boss.type].hp*bossfight.boss.tier
    bossfight.c_bar_w = bossfight.c_bar_w + (((bossfight.bar_w-10)/hp_max*bossfight.boss.hp) - bossfight.c_bar_w) * 0.2
  end

  bossfight.hud_pos = graphics.zoom(not (bossfight.active and bossfight.pause <= 0), bossfight.hud_pos, screen.h - 36, screen.h, dt * 12)
end

hud.draw = function()
  love.graphics.draw(img.board, hud_pos, 4)
  if char.hp > 0 then
    love.graphics.print(hud.num_to_str(char.hp), hud_pos+19, 11)
  else
    love.graphics.print("000", hud_pos+19, 11)
  end
  love.graphics.print(hud.num_to_str(char.ammo), hud_pos+65, 11)
  love.graphics.print(hud.num_to_str(money), hud_pos+111, 11)
  if state == "game" or state == "pause" or state == "over" then
    love.graphics.print(hud.num_to_str(math.ceil(level.scroll.goal-level.scroll.pos)), hud_pos+157, 11)
  else
    love.graphics.print("000", hud_pos+157, 11)
  end

  if (state == "game" or state == "pause" or state == "over") and (bossfight.active and bossfight.pause <= 0) then
    love.graphics.setCanvas(canvas.healthbar)
    love.graphics.clear()
    local info = enemy_info[bossfight.boss.type]
    hud.healthbar(bossfight.boss.hp*bossfight.boss.tier, info.hp*bossfight.boss.tier, info.name)
    love.graphics.setCanvas(canvas.menu)
  end
  love.graphics.draw(canvas.healthbar, (screen.w-bossfight.bar_w)/2, bossfight.hud_pos)
end

hud.num_to_str = function(num)
  if num > 999 then
    return "999"
  elseif num < 0 then
    return "000"
  else
    local str = tostring(num)
    for i = 1, 3-string.len(str) do
      str = "0"..str
    end
    return str
  end
end

hud.healthbar = function(hp, hp_max, name)
  local bar_length = bossfight.bar_w
  local cell_width = (bar_length-10)/hp_max
  love.graphics.setColor(palette.brown)
  love.graphics.rectangle("fill", 0, 10, bar_length, 22)
  love.graphics.setColor(palette.red)
  love.graphics.rectangle("fill", 5, 10, bossfight.c_bar_w, 22)
  love.graphics.setColor(255, 255, 255)
  love.graphics.draw(img.hpbox, 0, 0)
  for i = 1, hp_max-1 do
    love.graphics.draw(img.hpdash, cell_width*i+5-2, 10)
  end
  love.graphics.print(name, (bar_length-font:getWidth(name))/2, 4)
end

return hud
