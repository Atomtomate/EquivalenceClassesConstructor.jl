@testset "build equivalence list" begin
    pred1 = Predicate((x,y) -> x == y)
    indl1 = -10:10
    eqC_1 = EquivalenceClasses(pred1, indl1)
    @test typeof(eqC_1) === EquivalenceClasses
    @test eqC_1.pred === pred1
    @test all(eqC_1.indl .== indl1)
    @test typeof(eqC_1.classes) <: AbstractArray
end

@testset "complete tests" begin
    pred1 = EquivalenceClassesConstructor.Predicate((x,y) -> (x .== -y || x .== (y .+ 10)))
    test_med_ind = (i for i in -300:300);
    #test_large_ind = ([i,j,k] for i in -30:20 for j in -10:30 for k in -20:30);
    test_large_ind = ([el...] for el in Iterators.product(-30:30, -10:30, -20:30))
end
