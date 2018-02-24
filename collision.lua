local collision = {}

collision.overlap = function(a, b)
  return (a.p.x-b.p.x)*(a.p.x-b.p.x)+(a.p.y-b.p.y)*(a.p.y-b.p.y) <= (a.r+b.r)*(a.r+b.r)
end

return collision
