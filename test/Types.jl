@testset "ExpandMapping" begin
    m1 = Mapping(x -> [x])
    cl1 = find_classes(m1, 1:5)
    em = ExpandMapping(cl1)
    @test all(sort(collect(keys(cl1))) .== sort(collect(keys(em.map))))
    @test all(minimal_set(em) .== sort(collect(keys(em.map))))
end
