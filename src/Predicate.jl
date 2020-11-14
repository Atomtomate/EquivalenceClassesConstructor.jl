
# TODO: limit types for arguments of f
struct Predicate
  f::Function
end

(p::Predicate)(x,y) = p.f(x,y)

# ====================  Auxiliary functions ====================

function check_for_equivalence_relation(f::Predicate, domain)
  for (i,el1) in enumerate(domain)
    for el2 in domain[i+1:end]
      !(f(el1,el2) == f(el2,el1)) && return false
    end
  end
  return true
end
