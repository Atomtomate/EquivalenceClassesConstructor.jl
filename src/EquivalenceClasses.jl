struct EquivalenceClasses
    pred::Union{Predicate,Mapping}
    map::IndexMapping
end

"""
    EquivalenceClasses(pred::Predicate, indl::AbstractArray)

Constructs an EquivalenceClasses struct from a predicate `pred`
over `n` indices in the list `indl`.
This inputs requires `n^2` operations in order to create the
adjecency matrix. For large inputs a mapping is therefore 
preferabel.

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(pred::Predicate, indl::AbstractArray)
    return EquivalenceClasses(pred, find_classes(pred,indl))
end


"""
    EquivalenceClasses(m::Mapping, indl::AbstractArray)

Constructs an EquivalenceClasses struct from a mapping `m`
over the indices in the list `indl`.

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(m::Mapping, indl::AbstractArray)
  return EquivalenceClasses(m, find_classes(m,indl))
end


# ====================  Auxiliary functions ====================

Base.show(io::IO, z::EquivalenceClasses) = print(io, "Equivalence classes of ", 
                                                 z.pred, 
                                                 " over set ",
                                                 z.indl,
                                                 " with classes ",
                                                 z.classes)
