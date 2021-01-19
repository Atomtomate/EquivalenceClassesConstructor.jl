"""
     invertDict(D::OrderedDict; sorted=false)

For a given injective dictionary `D` with key set `K` and value set `V`, this
function returns a dict with key set `V` and values `Array{K}`.
"""
function invertDict(D::OrderedDict; sorted=false)
    uniqueV = unique(values(D))
    invD = OrderedDict{valtype(D),Array{keytype(D),1}}(e => Array{valtype(D),1}() for e  in uniqueV)
    for (k,v) in D
		!(v == k) && push!(invD[v], k)
    end
    if sorted
        for k in keys(invD)
            sort!(invD[k]) 
        end
    end
    return invD
end

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
