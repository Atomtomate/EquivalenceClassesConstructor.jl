# index stuff here
const IndexList = AbstractArray

struct EquivalenceClasses
  pred::Predicate
  indl::IndexList
  classes::Array
end

"""
    EquivalenceClasses(pred, indl)

Constructs an EquivalenceClasses struct from a predicate `pred`
with indices in the list `indl`.
`pred` needs to be a equivalence relation: reflexivity, symmetry
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
