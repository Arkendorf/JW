local ai = {}

ai.load = {}

ai.load[1] = function(i, v) -- "basic"
end

ai.update = {}

ai.update[1] = function(i, v, dt) -- "basic"
  v.p = vector.sum(v.p, v.d)
end

return ai
