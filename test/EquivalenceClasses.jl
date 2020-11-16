@testset "build equivalence list" begin
    pred1 = Predicate((x,y) -> x == y)
    indl1 = -10:10
    eqC_1 = EquivalenceClasses(pred1, indl1)
    @test typeof(eqC_1) === EquivalenceClasses
    @test eqC_1.pred === pred1
    @test all(eqC_1.indl .== indl1)
    @test typeof(eqC_1.classes) <: AbstractArray
end
