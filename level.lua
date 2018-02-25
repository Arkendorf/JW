local level = {}

level.load = function()
  level_score = {max = 12, current = 0}
  scroll = {pos = 0, v = 0}
end

level.update = function(dt)
  -- recalculate level score
  level_score.current = 0
  local n = 0
  for i, v in pairs(enemies) do
    level_score.current = level_score.current + enemy_info[v.type].score
    n = n + 1
  end
  level_score.current = level_score.current * n -- the more enemies, the more difficult

  -- add new enemy if necessary
  if level_score.current < level_score.max then
    enemy.new("crosser")
  end
end

level.draw = function()
end

return level
