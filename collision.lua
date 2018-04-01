local collision = {}

collision.overlap = function(a, b, s)
  return (a.p.x-b.p.x)*(a.p.x-b.p.x)+(a.p.y-b.p.y)*(a.p.y-b.p.y) <= (a.r+b.r)*(a.r+b.r)*(s or 1)
end

return collision
