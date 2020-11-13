include("../src/predicate.jl")
@testset begin
    pred1 = Predicate((x,y) -> x == y)
    @test pred1(1,1) 
    @test !pred1(1,2) 
end
