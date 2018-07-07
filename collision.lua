local collision = {}

collision.overlap = function(a, b, s)
  return (a.p.x-b.p.x)*(a.p.x-b.p.x)+(a.p.y-b.p.y)*(a.p.y-b.p.y) <= (a.r+b.r)*(a.r+b.r)*(s or 1)
end

collision.bullet = function(p1, p2, d)
  if collision.overlap(p1, p2) then
    return true
  end
  local f = vector.sub(p1.p, p2.p)
  local a = vector.dot(d, d)
  local b = 2*vector.dot(f, d)
  local c = vector.dot(f, f) - (p1.r+p2.r)*(p1.r+p2.r)
  local  disc = b*b-4*a*c
  if disc >= 0 then
    disc = math.sqrt(disc)
    local t1 = (-b - disc)/(2*a)
    local t2 = (-b + disc)/(2*a)
    if (( t1 >= 0 and t1 <= 1 ) or ( t2 >= 0 and t2 <= 1 )) then
      return true
    end
  end
  return false
end

return collision
