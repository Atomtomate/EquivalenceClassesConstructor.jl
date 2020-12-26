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

@testset "ReduceMap" begin
    m2 = Mapping(x -> [-x])
    cl2 = find_classes(m2, -3:5)
    @test_throws MethodError ReduceMap(cl2)
    @test ReduceMap(cl2, collect(-3:5)) == Dict(3 => -3, -3 => -3, 2 => -2, -2=>-2, 1 => -1, -1 => -1, 0 => 0, 4 => 4, 5 => 5)
end

@testset "ExpandMap" begin
    m1 = Mapping(x -> [x])
    m2 = Mapping(x -> [-x])
    cl1 = find_classes(m1, 1:5)
    cl2 = find_classes(m2, -3:5)
    em = ExpandMap(cl1, collect(1:5))
    em2 = ExpandMap(cl2)
    @test sort(collect(keys(cl1.classes))) == sort(collect(keys(em.map)))
    @test minimal_set(em) == sort(collect(keys(em.map)))
    @test minimal_set(em, sorted=true) == [1,2,3,4,5]
    @test sort(collect(keys(ExpandMap(cl1.classes, collect(1:5), sorted=true).map))) == [1,2,3,4,5]
    @test Int.(sort(collect(keys(em2.map)))) == [1,2,3,4,8,9]
    @test all(sort(collect(values(em2.map))) .== [[-3,3],[-2],[-1,1],[0],[4],[5]])
end

@testset "build equivalence list" begin
    pred1 = Predicate((x,y) -> x == y)
    indl1 = 1:5
    eqC_1 = EquivalenceClasses(pred1, indl1)
    sol1_cl = [1,2,3,4,5]
    sol1 = Dict{Int64,Array{Int64,1}}(zip(1:5,[[], [], [], [], []]))
    @test typeof(eqC_1) === EquivalenceClasses{Int64}
    @test typeof(eqC_1.classes) === Dict{Int64,UInt32}
    @test eqC_1.f === pred1
    @test sort(collect(values(eqC_1.classes))) == sol1_cl
end

@testset "complete tests" begin
    pred1 = EquivalenceClassesConstructor.Predicate((x,y) -> (x .== -y || x .== (y .+ 10)))
    test_med_ind = (i for i in -300:300);
    #test_large_ind = ([i,j,k] for i in -30:20 for j in -10:30 for k in -20:30);
    test_large_ind = ([el...] for el in Iterators.product(-30:30, -10:30, -20:30))
end
