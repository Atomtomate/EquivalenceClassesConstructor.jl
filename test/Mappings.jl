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
    m2 = Mapping(x -> [-x])
    m3 = Mapping(x -> [x+3,x-3])
    m5 = Mapping(x -> [x-3])
    @test m1(1) == [1]
    @test m1(1) == m1.f(1)
end
