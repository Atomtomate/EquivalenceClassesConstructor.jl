# index stuff here
const IndexList = AbstractArray

struct EquivalenceClasses
  pred::Predicate
  indl::IndexList
  adjacencyMatrix::
  classes::AbstractArray{AbstractArray{IndexList,1},1}
end

Base.show(io::IO, z::EquivalenceClasses) = print(io, "naive show: ", z.pred, z.indl, z.classes)

# Auxiliary functions
function build_classes_naive(pred, indl)
  return []
end

"""
    EquivalenceClasses(pred, indl)

Constructs an EquivalenceClasses struct from a predicate `pred`
with indices in the list `indl`

# Examples
```
julia> EquivalenceClasses(Predicate((x,y)->all(x .== -y)),
                          [(i,j) for i in -2:2 for j in 4:7])

```
"""
function EquivalenceClasses(pred::Predicate, indl::IndexList)
  return EquivalenceClasses(pred, indl, build_classes_naive(pred, indl))
end
