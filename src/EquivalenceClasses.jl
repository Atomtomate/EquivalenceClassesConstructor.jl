# index stuff here
const IndexList = AbstractArray

struct EquivalenceClasses
  pred::Predicate
  indl::IndexList
  classes::AbstractArray{AbstractArray{IndexList,1},1}
end

Base.show(io::IO, z::EquivalenceClasses) = print(io, "naive show: ", z.pred, z.indl, z.classes)

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

build_classes_naive(pred, indl) = []

# ====================  Auxiliary functions ====================

"""
    build_adj_matrix(pred, indl)

Constructs adjacency matrix with vertices from `indl` and edges
from `pred(i,j)` where `i,j ∈ indl`
"""
function build_adj_matrix(pred::Predicate, indl)
  adj = BitArray(undef, length(indl),length(indl))
  for (i,ind) in enumerate(indl)
    adj[i,i] = true
    for (j,ind2) in enumerate(indl[i+1:end])
      println(i, ", ",j+i, ": ", pred(ind, ind2))
      adj[i,j+i] = pred(ind,ind2)
      adj[j+i,i] = pred(ind2,ind)
    end
  end

  return adj
end
