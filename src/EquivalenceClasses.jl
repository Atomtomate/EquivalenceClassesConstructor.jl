# index stuff here
const IndexList = Union{AbstractArray, Base.Generator}

struct IndexSet
    full::IndexList
    reduced::IndexList
    mappings::Dict
end

struct EquivalenceClasses
  pred::Predicate
  indl::IndexList
  classes::Array
end

"""
    EquivalenceClasses(pred::Predicate, indl::IndexList)

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
function EquivalenceClasses(pred::Predicate, indl::IndexList)
  return EquivalenceClasses(pred, indl, find_classes(pred, indl))
end


"""
    EquivalenceClasses(m::Mapping, indl::IndexList)

Constructs an EquivalenceClasses struct from a mapping `m`
over the indices in the list `indl`.
and transitivity will be enforced by the algorithm creating the 
adjecency matrix.

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(pred::Predicate, indl::IndexList)
  return EquivalenceClasses(pred, indl, find_classes(pred, indl))
end


# ====================  Auxiliary functions ====================

Base.show(io::IO, z::EquivalenceClasses) = print(io, "Equivalence classes of ", 
                                                 z.pred, 
                                                 " over index list ",
                                                 z.indl,
                                                 " with classes ",
                                                 z.classes)
