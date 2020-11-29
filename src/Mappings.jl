# TODO: limit types for arguments of f
struct Predicate
  f::Function
end

struct Mapping
  f::Function
end

(p::Predicate)(x,y) = p.f(x,y)
(m::Mapping)(x) = m.f(x)

# ====================  Auxiliary functions ====================

"""
    check_for_equivalence_relation(f::Predicate, dom)

Given a Predicate `f` over a domain `dom`, return `true` if `f`
is a equivalence relation, `false` otherwise.
One can create a symmetric equivalency relation with [`make_symmetric(f)`](@ref)
TODO: check transitivity.

# Examples
```
julia> check_for_equivalence_relation(Predicate((x,y) -> x == -y), -5:10)
true
julia> check_for_equivalence_relation(Predicate((x,y) -> x == y+2), -1:10)
false
```
"""
function check_for_equivalence_relation(f::Predicate, dom)
  for (i,el1) in enumerate(dom)
    for el2 in dom
      !(f(el1,el2) == f(el2,el1)) && return false
    end
  end
  #TODO: check transitivity
  return true
end
