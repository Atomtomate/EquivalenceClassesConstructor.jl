struct Predicate
  f::Function
end

(p::Predicate)(x,y) = p.f(x,y)
