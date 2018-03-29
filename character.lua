local character = {}

character.load = function()
  char = {p = {x = 200, y = 300}, d = {x = 0, y = 0}, a = {x = 0, y = 0}, hp = 3, inv = 0, atk = 0, r = 16, ammo = 32,
          weapons = {1, 0}}
  char_info = {speed = 1, stop = 0.8, atk_delay = .2, inv_time = 1, hp_max = 3, ammo_max = 32}
end

character.update = function(dt)
  -- movement
  if love.keyboard.isDown("right") then
    char.d.x = char.d.x + char_info.speed
  end
  if love.keyboard.isDown("left") then
    char.d.x = char.d.x - char_info.speed
  end
  if love.keyboard.isDown("down") then
    char.d.y = char.d.y + char_info.speed
  end
  if love.keyboard.isDown("up") then
    char.d.y = char.d.y - char_info.speed
  end

  -- adjust char pos
  char.p = vector.sum(char.p, vector.scale(dt * 60, char.d))

  -- adjust char angle
  char.a.x = char.d.x * (1 - char_info.stop) * 0.5 -- 1 results in +- 45 degrees, 0 results in +- 0 degrees
  char.a.y = - 1
  char.a = vector.norm(char.a)

  -- adjust char velocity
  char.d = vector.scale(char_info.stop, char.d)

  -- attack
  if love.keyboard.isDown("z") and char.atk <= 0 and char.ammo > 0 then
    bullet.new("basic", char.p, vector.sum(char.a, vector.scale(0.1, char.d)), 1) -- directin is combo of char's direction and movement
    char.ammo = char.ammo - 1 -- decrease ammo
    char.atk = char_info.atk_delay
    stats.shots = stats.shots + 1 -- increase 'shots' stat
  elseif char.atk > 0 then
    char.atk = char.atk - dt
  end

  if char.inv > 0 then-- lower invincibility
    char.inv = char.inv - dt
  else -- damage char on collision with enemy
    for i, v in pairs(enemies) do
      if collision.overlap(char, v) then
        char.hp = char.hp - 1
        char.inv = char_info.inv_time
        stats.dmg = stats.dmg + 1 -- increase 'dmg' stat
      end
    end
  end

  -- game over if char has no health
  if char.hp <= 0 then
    love.event.quit()
  end
end

character.draw = function()
  -- flash if invincibile
  if char.inv > 0 then
    love.graphics.setColor(255, 255, 255, 255*math.floor(math.sin(char.inv*16)+0.5))
  end

  -- draw char
  love.graphics.circle("line", char.p.x, char.p.y, char.r, 32)
  love.graphics.line(char.p.x, char.p.y, char.p.x+char.a.x*16, char.p.y+char.a.y*16)
  love.graphics.draw(img.biplane, char.p.x, char.p.y, math.atan2(char.a.y, char.a.x), 1, 1, 16, 16)

  -- reset color
  love.graphics.setColor(255, 255, 255)
end

return character
