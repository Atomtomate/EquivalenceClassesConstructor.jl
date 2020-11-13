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
