@testset "build equivalence list" begin
    pred1 = Predicate((x,y) -> x == y)
    indl1 = -10:10
    @test typeof(EquivalenceClasses(pred1, indl1)) === EquivalenceClasses
end
