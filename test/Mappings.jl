@testset "basic predicate tests" begin
    pred1 = Predicate((x,y) -> x == y)
    pred2 = Predicate((x,y) -> x != y)
    pred3 = Predicate((x,y) -> all(x .== -y)) 
    @test pred1(1,1) 
    @test !pred1(1,2) 
    @test !pred2(1,1) 
    @test pred2(1,2) 
    @test pred3([1,2],[-1,-2])
    @test !pred3([1,2],[2,3])
end

@testset "is predicate equivalence relation" begin
    pred1 = Predicate((x,y) -> x == y)
    pred2 = Predicate((x,y) -> x != y)
    pred3 = Predicate((x,y) -> all(x .== -y)) 
    pred4 = Predicate((x,y) -> x == y+3) 
    @test check_for_equivalence_relation(pred1, -11:10)
    @test check_for_equivalence_relation(pred2, -7:10)
    @test check_for_equivalence_relation(pred3, [[i,j] for i in -7:10 for j in -2:8])
    @test !check_for_equivalence_relation(pred4, -7:10)
end

@testset "mappings" begin
    m1 = Mapping(x -> [x])
    sol1 = Dict(zip(1:5,[[1], [2], [3], [4], [5]]))
    m2 = Mapping(x -> [-x])
    sol2 = Dict(0 => [0],-4 => [-4],-3 => [-3, 3],-2 => [-2, 2],-1 => [-1, 1])
    m3 = Mapping(x -> [x+3,x-3])
    m5 = Mapping(x -> [x-3])
    sol3 = Dict(-4 => [-4, -1, 2],-3 => [-3, 0, 3],-2 => [-2, 1])
    @test find_classes(m1, 1:5) == sol1
    @test find_classes(m2, -4:3,sorted=true) == sol2
    @test find_classes(m3, -4:3,sorted=true) == sol3
    @test !(find_classes(m5, -4:3) == sol3)
end
