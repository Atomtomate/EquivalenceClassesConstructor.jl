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
The boolean `sorted` can be set to true, if the resulting expand map should be 
sorted (one should make sure, that the elements of `vl` are comparable).

# Examples
```
julia> find_classes(Mapping(x-> [-x]), -2:4)
"IndexMapping{Int64}[Full: -2:4, ExpandMap: Dict(0 => [0],4 => [4],-2 => [-2, 2],-1 => [-1, 1],3 => [3])]"
```
"""
function find_classes(m::Mapping, vl::AbstractArray; closed=false, sorted=false)
  classes = Dict(zip(vl,vl))
  openL = Dict(zip(vl,trues(length(vl))))       # mark all vertices as open (not visited)
  for vi in vl                                  # visit each entry at least once
    !openL[vi] && continue                      # if entry already checked, continue
    classes[vi] = vi                            # current node has class cc
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
          classes[el] = vi
      end
    end
    sum(values(openL)) == 0 && break                    # no more open vertices left, return
  end
  expandMap = invertDict(classes, sorted=sorted)
  return IndexMapping(vl, expandMap)
end

function find_classes2(m::Mapping, vl::AbstractArray; closed=false, sorted=false)
  vl_int = 1:length(vl)
  classes = Dict(zip(vl_int,vl_int))
  classes_to_int = Dict(zip(vl,vl_int))
  openL = Dict(zip(vl_int,trues(length(vl))))       # mark all vertices as open (not visited)
  i = 0
  j = 0
  for vi in vl_int                                  # visit each entry at least once
    j += 1
    !openL[vi] && continue                      # if entry already checked, continue
    i%100 == 0 && println(i, " of ", length(vl), " in $j todo: ", sum(values(openL)))
    i += 1
    classes[vi] = vi                            # current node has class cc
    searchL = [vi]                              # add current vertex to search list
    while !isempty(searchL)                     # search through all reachable entries
      vj = pop!(searchL)                        # first vertex in index List is next candidate
      !openL[vj] && continue
      openL[vj] = false                         # set current node to visited
      #println("..")
      int_classes = (classes_to_int[el] for el in m(vl[vj]) if el in keys(classes_to_int))
      neighbors = (el for el in int_classes if !openL[el])
      #if closed
          #filter(x-> openL[x], get.(classes_to_int,m(vl[vj]),0))    # add all adjacent AND open vertices to class
      #else
      #    filter(x->(x in keys(openL)) && openL[x], get.(classes_to_int,m(vl[vj]),0))    # add all adjacent AND open vertices to class, skip entries outside vl
      #end
      searchL = union(neighbors,searchL)        # without double entries
      for el in searchL
          classes[el] = vi
      end
    end
    sum(values(openL)) == 0 && break                    # no more open vertices left, return
  end
  println("done, mapping back")
  classes_final = Dict(zip(vl, (vl[i] for i in classes)))
  println(classes_final)

  println("done")
  expandMap = invertDict(classes_final, sorted=sorted)
  return IndexMapping(collect(vl), expandMap)
end


"""
    find_classes(pred::Predicate, vl; isSymmetric=false)

returns an array of length `length(vl)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
See `find_classes(m::Mapping, vl)` for more information.
"""
function find_classes(pred::Predicate, vl::AbstractArray; isSymmetric=false, sorted=false)
    adj = isSymmetric ? build_adj_matrix(pred, vl) : 
        build_adj_matrix(Predicate((x,y) ->(pred(x,y) || pred(y,x))), vl)
    expandMap = invertDict(Dict(zip(vl,vl[find_classes(adj)])), sorted=sorted)
    return IndexMapping(vl, expandMap)
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
