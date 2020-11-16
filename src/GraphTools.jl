
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
"""
function find_classes(adj::BitArray{2})
  classes = collect(1:size(adj,1))      # every node has its own class at the start
  for i in 1:size(adj,1)
    for j in (i+1):size(adj,2)
      adj[i,j] && (classes[j] = classes[i])   # merge class of neighbour with current node
    end
  end
  return classes
end

"""
    find_classes(pred::Predicate, indl)

returns an array of length `length(indl)` with each entry with index `i` being
a unique identifier for the equivalency class of the node `i`.
"""
function find_classes(pred::Predicate, indl::AbstractArray)
  classes = collect(1:length(indl))      # every node has its own class at the start
  for (i,ind) in enumerate(indl)
    for j in (i+1):length(indl)
      (pred(ind,indl[j]) || pred(indl[j],ind)) && (classes[j] = classes[i])   # merge class of neighbour with current node
    end
  end
  return classes
end
