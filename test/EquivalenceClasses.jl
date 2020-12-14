@testset "build equivalence list" begin
    pred1 = Predicate((x,y) -> x == y)
    indl1 = 1:5
    eqC_1 = EquivalenceClasses(pred1, indl1)
    sol1_cl = [1,2,3,4,5]
    sol1 = Dict{Int64,Array{Int64,1}}(zip(1:5,[[], [], [], [], []]))
    @test typeof(eqC_1) === EquivalenceClasses{Int64}
    @test typeof(eqC_1.classes) === Dict{Int64,Int64}
    @test eqC_1.f === pred1
    @test sort(collect(values(eqC_1.classes))) == sol1_cl
end

@testset "complete tests" begin
    pred1 = EquivalenceClassesConstructor.Predicate((x,y) -> (x .== -y || x .== (y .+ 10)))
    test_med_ind = (i for i in -300:300);
    #test_large_ind = ([i,j,k] for i in -30:20 for j in -10:30 for k in -20:30);
    test_large_ind = ([el...] for el in Iterators.product(-30:30, -10:30, -20:30))
end
