@testset "basic predicate tests" begin
    @test pred1(1,1) 
    @test !pred1(1,2) 
    @test !pred2(1,1) 
    @test pred2(1,2) 
    @test pred3([1,2],[-1,-2])
    @test !pred3([1,2],[2,3])
end

@testset "is predicate equivalence relation" begin
    @test check_for_equivalence_relation(pred1, -11:10)
    @test check_for_equivalence_relation(pred2, -7:10)
    @test check_for_equivalence_relation(pred3, [[i,j] for i in -7:10 for j in -2:8])
    @test !check_for_equivalence_relation(pred4, -7:10)
end

@testset "mappings" begin
    @test m1(1) == [1]
    @test m1(1) == m1.f(1)
end

@testset "ReduceMap" begin
    @test_throws TypeError ReduceMap(1 => 2.0)   
    @test ReduceMap(1=>2).map == Dict(1=>2)
    @test ReduceMap(Dict(1=>2)).map == Dict(1=>2)
    @test ReduceMap(Dict(1=>UInt32(2))).map == Dict(1=>UInt32(2))
    @test ReduceMap(1=>2, 3=>4).map == Dict(1=>2,3=>4)
    @test ReduceMap(i => i+1 for i in 1:2) == Dict(1=>2,2=>3)
    @test ReduceMap(zip([1,3],[2,4])).map == Dict(1=>2, 3=>4)
    @test cl2.map == cl2_res_index
    @test toDirectMap(cl2, vl2) == cl2_res_direct 
    @test toIndexMap(toDirectMap(cl2, vl2),vl2) == cl2_res_index
    @test minimal_set(cl2) == sort(collect(unique(values(cl2.map))))
    @test minimal_set(cl2, sorted=true) == UInt32.([1,2,3,4,8,9])
end

@testset "ExpandMap" begin
    em1 = ExpandMap(cl1)
    em2 = ExpandMap(cl2)
    em2_2 = ExpandMap(cl2, vl2)
    @test minimal_set(em2) == sort(collect(unique(values(cl2.map))))
    @test minimal_set(em2, sorted=true) == UInt32.([1,2,3,4,8,9])
    @test sort(collect(keys(ExpandMap(cl1, sorted=true).map))) == [1,2,3,4,5]
    @test Int.(sort(collect(keys(em2.map)))) == [1,2,3,4,8,9]
    @test all(sort(collect(values(em2.map))) .== [[-3,3],[-2],[-1,1],[0],[4],[5]])
    @test ExpandMap(toDirectMap(cl2, vl2)) == em2_2
    @test ExpandMap(cl2, vl2) == em2_2
end

@testset "build equivalence list" begin
    indl1 = 1:5
    eqC_1 = EquivalenceClasses(pred1, indl1)
    sol1_cl = [1,2,3,4,5]
    sol1 = Dict{Int64,Array{Int64,1}}(zip(1:5,[[], [], [], [], []]))
    @test typeof(eqC_1) === ReduceMap{Int64,UInt32}
    @test typeof(eqC_1.map) === Dict{Int64,UInt32}
    @test sort(collect(values(eqC_1.map))) == sol1_cl
end

@testset "complete tests" begin
    #pred1 = EquivalenceClassesConstructor.Predicate((x,y) -> (x .== -y || x .== (y .+ 10)))
    #test_med_ind = (i for i in -300:300);
    #test_large_ind = ([el...] for el in Iterators.product(-30:30, -10:30, -20:30))
end
