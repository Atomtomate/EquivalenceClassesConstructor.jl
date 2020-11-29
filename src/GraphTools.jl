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
    for (j,ind2) in enumerate(Iterators.drop(indl,i))
      adj[i,j+i] = pred(ind,ind2) || pred(ind2,ind)
      adj[j+i,i] = adj[i,j+i]
    end
  end
  return adj
end

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
  classes = collect(1:size(adj,1))              # every node has its own class at the start
  cc = 1                                        # current class counter
  openL = trues(size(adj,1))                    # no vertices have been visited yet
  for i in 1:size(adj,1)                        # check all vertices at least once
    !openL[i] && continue                       # if node already checked, continue
    classes[i] = cc                             # current node has class cc
    indL = [i]                                  # add current vertex to search list
    while !isempty(indL)                        # search through all reachable vertices
      j = pop!(indL)                            # first vertex in index List is next candidate
      !openL[j] && continue
      openL[j] = false                          # set current node to visited
      neighbors = findall(adj[i,:] .& openL)    # add all adjacent AND open vertices to class
      indL = union(neighbors,indL)              # without double entries
      classes[indL] .= cc                       # set all neighbors to current class
    end
    cc += 1
    sum(openL) == 0 && break                    # no more open vertices left, return
  end
  return classes
end


"""
    find_classes(m::Mapping, vl)

returns an array of length `size(adj,1)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
Uses a mapping function `m(x) = y` and an vertex list `vl` to construct graph i
n place.
`m` has to be symmetric (i.e. `m(x) = y => m(y) = x`)!
In case the vertex list is closed under the mapping (i.e. there exist no `x` in 
`vl` such that `m(x)` is not in `vl`), `closed` can be set to `false` in order
to improve performace.

# Examples
```
julia> find_classes(Mapping(x-> [-x]), -2:4)
Dict(0 => 3,4 => 5,2 => 1,-2 => 1,-1 => 2,3 => 4,1 => 2)
```
"""
function find_classes(m::Mapping, vl::AbstractArray; closed=false)
  classes = Dict(zip(vl,1:length(vl)))
  cc = 1                                        # current class counter
  openL = Dict(zip(vl,trues(length(vl))))       # mark all vertices as open (not visited)
  for vi in vl                                  # visit each entry at least once
    !openL[vi] && continue                      # if entry already checked, continue
    classes[vi] = cc                            # current node has class cc
    searchL = [vi]                              # add current vertex to search list
    while !isempty(searchL)                     # search through all reachable entries
      vj = pop!(searchL)                        # first vertex in index List is next candidate
      !openL[vj] && continue
      openL[vj] = false                         # set current node to visited
      neighbors = if closed
        filter(x-> openL[x], m(vj))    # add all adjacent AND open vertices to class
      else
        filter(x->(x in keys(openL)) && openL[x], m(vj))    # add all adjacent AND open vertices to class, skip entries outside vl
      end
      searchL = union(neighbors,searchL)        # without double entries
      for el in searchL
          classes[el] = cc
      end
    end
    cc += 1
    sum(values(openL)) == 0 && break                    # no more open vertices left, return
  end
  return classes
end


"""
    find_classes(pred::Predicate, indl; isSymmetric=false)

returns an array of length `length(indl)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
"""
function find_classes(pred::Predicate, indl::IndexList; isSymmetric=false)
  adj = isSymmetric ? build_adj_matrix(pred, indl) : 
    build_adj_matrix(Predicate((x,y) ->(pred(x,y) || pred(y,x))), indl)
  return find_classes(adj)
end
