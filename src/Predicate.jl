
# TODO: limit types for arguments of f
struct Predicate
  f::Function
end

(p::Predicate)(x,y) = p.f(x,y)

# ====================  Auxiliary functions ====================

"""
    check_for_equivalence_relation(f::Predicate, dom)

Given a Predicate `f` over a domain `dom`, return `true` if `f`
is a equivalence relation, `false` otherwise.
One can create a symmetric equivalency relation with [`make_symmetric(f)`](@ref)

# Examples
```
true
julia> check_for_equivalence_relation(Predicate((x,y) -> x == y+2), -1:10)
false
```
"""
function check_for_equivalence_relation(f::Predicate, dom)
  for (i,el1) in enumerate(dom)
    for el2 in dom[i+1:end]
      !(f(el1,el2) == f(el2,el1)) && return false
    end
  end
  return true
end

"""
    make_symmetric(f::Predicate)

Create symmetric predicate from arbitrary predicateg
"""
function make_symmetric(f::Predicate)
  return f(x,y) || f(y,x)
end
