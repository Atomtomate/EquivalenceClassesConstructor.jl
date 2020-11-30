struct EquivalenceClasses
    pred::Union{Predicate,Mapping}
    map::IndexMapping
end

"""
    EquivalenceClasses(pred::Predicate, vl::AbstractArray)

Constructs an EquivalenceClasses struct from a predicate `pred`
over `n` indices in the list `vl`.
This inputs requires `n^2` operations in order to create the
adjecency matrix. For large inputs a mapping is therefore 
preferabel.
`sorted` can be set to `true` to force all lists of mappings 
between classes to be sorted

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(pred::Predicate, vl::AbstractArray; sorted=false)
    return EquivalenceClasses(pred, find_classes(pred,vl,sorted=sorted))
end


"""
    EquivalenceClasses(m::Mapping, vl::AbstractArray)

Constructs an EquivalenceClasses struct from a mapping `m`
over the indices in the list `vl`.
`sorted` can be set to `true` to force all lists of mappings 
between classes to be sorted

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(m::Mapping, vl::AbstractArray; sorted=false)
  return EquivalenceClasses(m, find_classes(m,vl,sorted=sorted))
end


# ====================  Auxiliary functions ====================

Base.show(io::IO, z::EquivalenceClasses) = show(io, "Equivalence Classes of $(z.pred): "*string(z.map))
