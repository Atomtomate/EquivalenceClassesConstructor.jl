@testset "ExpandMapping" begin
    m1 = Mapping(x -> [x])
    cl1 = find_classes(m1, 1:5)
    em = ExpandMapping(cl1)
    @test all(sort(collect(keys(cl1.classes))) .== sort(collect(keys(em.map))))
    @test all(minimal_set(em) .== sort(collect(keys(em.map))))
    @test all(minimal_set(em, sorted=true) .== [1,2,3,4,5])
    @test all(sort(collect(keys(ExpandMapping(1:5, cl1.classes, sorted=true).map))) .== [1,2,3,4,5])
end
