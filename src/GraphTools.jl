# ====================  Find Classes  ====================
"""
    find_classes(adj::BitArray{2})

returns an array of length `size(adj,1)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
Uses adjacency matrix as input. I.e. graph needs to be constructed before.
 
# Examples
```
julia> find_classes(convert(BitArray, [0 1 0; 1 0 0; 0 0 0]))
[1, 1, 2]
```
"""
function find_classes(adj::BitArray{2})
  vlR = UnitRange{UInt32}(1:size(adj,1))
  classes = collect(vlR)                        # every node has its own class at the start
  openL = trues(size(adj,1))                    # no vertices have been visited yet
  for i in vlR                                  # check all vertices at least once
    !openL[i] && continue                       # if node already checked, continue
    classes[i] = i                              # current node has class i
    indL = [i]                                  # add current vertex to search list
    while !isempty(indL)                        # search through all reachable vertices
      j = pop!(indL)                            # first vertex in index List is next candidate
      !openL[j] && continue
      openL[j] = false                          # set current node to visited
      neighbors = findall(adj[i,:] .& openL)    # add all adjacent AND open vertices to class
      indL = union(neighbors,indL)              # without double entries
      classes[indL] .= i                        # set all neighbors to current class
    end
    sum(openL) == 0 && break                    # no more open vertices left, return
  end
  return classes
end


"""
    find_classes(m::Mapping, vl; vl_len=length(vl), sorted=false)

returns an array of length `size(adj,1)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
Uses a mapping function `m(x) = y` and an vertex list `vl` to construct graph i
n place.
`m` has to be symmetric (i.e. `m(x) = y => m(y) = x`)!
In case the vertex list is closed under the mapping (i.e. there exist no `x` in 
`vl` such that `m(x)` is not in `vl`), `closed` can be set to `false` in order
to improve performace.
for that class. By specifying `continuous = true`,
`vl_len` can be specified explicitly in cases where `length(vl)` does not work 
(e.g. nested generator objects).
For performace reasons this function can also be called with a plain function 
instead of a Mapping.

# Examples
```
```
"""
find_classes(m::Mapping, vl::AbstractArray{T,1}; vl_len=length(vl)) where T = find_classes(m.f, vl, vl_len=vl_len)

function find_classes(m::Function, vl::AbstractArray{T,1}; vl_len=length(vl)) where T
  vlR = UnitRange{UInt32}(1:vl_len)
  classes = OrderedDict(zip(vl,vlR))
  openL = Dict(zip(vl,trues(vl_len)))           # mark all vertices as open (not visited)
  searchL = Stack{eltype(vl)}()
  @time @inbounds for i in vlR                  # visit each entry at least once
    vi = vl[i]
    if openL[vi]                              # if entry already checked, continue
      push!(searchL, vi)                    # add current vertex to search list
      while !isempty(searchL)               # search through all reachable entries
        vj = pop!(searchL)                # next vertex in index List is next candidate
        classes[vj] = i
        if openL[vj]
          openL[vj] = false             # set current node to visited
          for (j,el) in enumerate(m(vj))           # add all adjacent AND open vertices to class, skip entries outside vl
            if !(el in searchL) && haskey(openL,el) && openL[el]
                push!(searchL, el)
            end
          end
        end
      end
    end
  end
  return @inbounds ReduceMap(classes)
end

"""
    find_classes(pred::Predicate, vl; isSymmetric=false)

returns an array of length `length(vl)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
See `find_classes(m::Mapping, vl)` for more information.
"""
function find_classes(pred::Predicate, vl::AbstractArray; isSymmetric=false)
    adj = isSymmetric ? build_adj_matrix(pred, vl) : 
        build_adj_matrix(Predicate((x,y) ->(pred(x,y) || pred(y,x))), vl)
    @inbounds res = ReduceMap(OrderedDict(zip(vl, find_classes(adj))))
    return res
end


# ====================  Find Paths  ====================
function find_classes(m::Function, operations::Array{UInt32,1}, vl::AbstractArray{T,1}; vl_len=length(vl)) where T
  vlR = UnitRange{UInt32}(1:vl_len)
  parent = OrderedDict(zip(vl,vl))
  parent_edge = OrderedDict(zip(vl,zeros(UInt32,vl_len)))
  openL = Dict(zip(vl,trues(vl_len)))       # mark all vertices as open (not visited)
  searchL = Stack{eltype(vl)}()
  for i in vlR              # visit each entry at least once
    vi = vl[i]
    if openL[vi]                            # if entry already checked, continue
      push!(searchL, vi)                    # add current vertex to search list
      parent[vi] = vi
      parent_edge[vi] = 0x00000
      while !isempty(searchL)               # search through all reachable entries
        vj = pop!(searchL)                  # next vertex in index List is next candidate
        if openL[vj]
          openL[vj] = false                 # set current node to visited
          for (j,el) in enumerate(m(vj))    # add all adjacent AND open vertices to class, skip entries outside vl
              if !(el in searchL) && haskey(openL,el) && openL[el]
                push!(searchL, el)
                parent[el] = vj
                parent_edge[el] = operations[j]
            end
          end
        end
      end
    end
  end
  return parent, parent_edge
end

# ====================  Auxiliary functions ====================

"""
    build_adj_matrix(pred, vl)

Constructs adjacency matrix with vertices from `vl` and edges
from `pred(i,j)` where `i,j ∈ vl`
"""
function build_adj_matrix(pred::Predicate, vl)
  adj = BitArray(undef, length(vl),length(vl))
  for (i,ind) in enumerate(vl)
    adj[i,i] = true
    for (j,ind2) in enumerate(Iterators.drop(vl,i))
      adj[i,j+i] = pred(ind,ind2) || pred(ind2,ind)
      adj[j+i,i] = adj[i,j+i]
    end
  end
  return adj
end

#merge_classes()



# ====================  EquivalenceClasses Wrappers  ====================
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
    return find_classes(pred,vl)
end


"""
    EquivalenceClasses(m::Mapping, vl::AbstractArray)

Constructs an EquivalenceClasses struct from a mapping `m`
over the indices in the list `vl`.

# Examples
```
julia> EquivalenceClasses(Mapping((x)->[-x]),
                          [(i,j) for i in -2:2 for j in 4:7])
```
"""
function EquivalenceClasses(m::Mapping, vl::AbstractArray)
  return find_classes(m,vl)
end


#function parent_to_classes(parent_map::Dict{T,T})
#end
