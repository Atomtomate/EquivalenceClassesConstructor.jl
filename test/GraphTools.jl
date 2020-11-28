@testset "DFS" begin
    pred1 = Predicate((x,y) -> x == -y || x == y)
    indl1 = -2:3
    pred1_adj = build_adj_matrix(pred1, indl1)
    eqC_1 = EquivalenceClasses(pred1, indl1)
end

@testset "Adjacency Matrix" begin
    pred1 = Predicate((x,y) -> x == -y)
    pred2 = Predicate((x,y)->x==y+3)
    indl1 = -2:3
    indl2 = -3:5
    eqC_1 = EquivalenceClasses(pred1, indl1)
    adj2 = build_adj_matrix(pred2, indl2)
    @test all(build_adj_matrix(pred1, indl1) .== Bool[1 0 0 0 1 0; 0 1 0 1 0 0; 0 0 1 0 0 0; 0 1 0 1 0 0; 1 0 0 0 1 0; 0 0 0 0 0 1])
    #@test all(find_classes(adj2) == find_classes(pred2, indl2))
end

@testset "Find Classes Adj" begin
    adj1 = falses(5,5)
    adj2 = trues(5,5)
    adj3 = convert(BitArray, [0 1 0; 1 0 0; 0 0 0])
    println(find_classes(adj3))
    @test all(find_classes(adj1) .== collect(1:5))
    @test all(find_classes(adj2) .== ones(5))
    @test all(find_classes(adj3) .== [1, 1, 2])
end
