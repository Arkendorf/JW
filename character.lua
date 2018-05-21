local character = {}

local shader = require "shader"

character.load = function()
  char = {p = {x = 200, y = 300}, d = {x = 0, y = -1}, a = {x = 0, y = -1}, hp = 3, inv = 0, atk = 0, r = 8, ammo = 64, frame = 1, trail = 0}
char_info = {speed = 1, stop = .8, inv_time = 1, hp_max = 3, ammo_max = 64, weapons = {{type = 1, tier = 1}, {type = 0, tier = 1}}}
end

character.update = function(dt)
  -- movement
  if level.scroll.pos < level.scroll.goal or bossfight.active or bossfight.pause > 0 then -- no movement in intro/outro
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
  else
    char.p.x = character.zoom(char.p.x, screen.w/2, dt * 12)
    char.p.y = character.zoom(char.p.y, screen.h/2, dt * 12)
  end

  -- adjust char pos
  char.p = vector.sum(char.p, vector.scale(dt * 60, char.d))

  -- collide with edges
  if char.p.x-char.r*2 < 0 then
    char.p.x = char.r*2
  end
  if char.p.x+char.r*2 > screen.w then
    char.p.x = screen.w-char.r*2
  end
  if char.p.y-char.r*2 < 0 then
    char.p.y = char.r*2
  end
  if char.p.y+char.r*2 > screen.h then
    char.p.y = screen.h-char.r*2
  end

  -- adjust char angle
  char.a.x = char.d.x * (1 - char_info.stop) * 0.5 -- * 1 results in +- 45 degrees, * 0 results in +- 0 degrees
  char.a.y = - 1
  char.a = vector.norm(char.a)

  -- adjust char velocity
  char.d = vector.scale(char_info.stop, char.d)

  -- attack
  for i, v in ipairs({"z", "x"}) do
    if char_info.weapons[i].type > 0 then -- make sure weapon slot is filled
      local weapon = weapon_info[char_info.weapons[i].type]
      if love.keyboard.isDown(v) and char.atk <= 0 and char.ammo >= weapon.ammo then
        bullet.new(weapon.bullet, char.p, vector.sum(vector.scale((1.5-i)*2, char.a), vector.scale(0.1, char.d)), 1, char_info.weapons[i].tier) -- direction is combo of char's direction and movement
        char.ammo = char.ammo - weapon.ammo -- decrease ammo
        char.atk = weapon.delay -- pause between shots
        stats.shots = stats.shots + 1 -- increase 'shots' stat
      end
    end
  end
  if char.atk > 0 then
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
    state = "over"
    over.start()
  end

  -- update animation
  char.frame = char.frame + dt * 12
  if char.frame > #shipquad.char+1 then
    char.frame = 1
  end

  -- update trail
  if char.trail <= 0 then
    enemy.dmg_particle(char.p, {x = 0, y = -1}, {x = 0, y = -1}, char.hp, char_info.hp_max)
    char.trail = .2
  else
    char.trail = char.trail - dt
  end
end

character.draw = function()
  -- flash if invincibile
  if char.inv > 0 and math.floor(math.sin(char.inv*8)+0.5) == 0 then
    love.graphics.setShader(shader.fill)
  end
  -- draw char
  love.graphics.draw(shipimg.char, shipquad.char[math.floor(char.frame)], math.floor(char.p.x), math.floor(char.p.y), math.atan2(char.a.y, char.a.x), 1, 1, 16, 16)

  -- reset shader
  love.graphics.setShader()
end

character.max_speed = function()
  return char_info.speed/(1-char_info.stop)*char_info.stop
end

character.zoom = function(num, goal, scalar)
  local dir = 1
  if num > goal then
    dir = -1
  end
  local zoom = graphics.zoom(dir == 1, num, goal, goal, scalar)
  local max = character.max_speed()
  if math.abs(zoom-num) > max then
    return num + max*dir
  else
    return zoom
  end
end

return character
