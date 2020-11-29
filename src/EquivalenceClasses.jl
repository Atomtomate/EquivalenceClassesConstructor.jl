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

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(pred::Predicate, vl::AbstractArray)
    return EquivalenceClasses(pred, find_classes(pred,vl))
end


"""
    EquivalenceClasses(m::Mapping, vl::AbstractArray)

Constructs an EquivalenceClasses struct from a mapping `m`
over the indices in the list `vl`.

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(m::Mapping, vl::AbstractArray)
  return EquivalenceClasses(m, find_classes(m,vl))
end


# ====================  Auxiliary functions ====================

Base.show(io::IO, z::EquivalenceClasses) = show(io, "Equivalence Classes of $(z.pred): "*string(z.map))
