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
      #println(i, ", ",j+i, ": ", pred(ind, ind2))
      adj[i,j+i] = pred(ind,ind2)
      adj[j+i,i] = pred(ind2,ind)
    end
  end

  return adj
end

"""
    DFS!(adj::BitArray{2}, start::Int64, visited::AbstractArray)

Depth first search in graph with adjacency matrix `adj` from `start`.
This will delete all reachable nodes (from `start`) in `open`.
"""
function DFS!(adj::BitArray{2}, start::Int64, open::AbstractArray)
  for i in 1:size(adj,2)
    #if adj[start,i]
  end
end
