@testset "DFS" begin
    pred1 = Predicate((x,y) -> x == -y || x == y)
    indl1 = -2:3
    pred1_adj = build_adj_matrix(pred1, indl1)
    eqC_1 = EquivalenceClasses(pred1, indl1)
end
