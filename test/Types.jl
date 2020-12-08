@testset "IndexMapping" begin
    m1 = Mapping(x -> [x])
    cl1 = find_classes(m1, 1:5)
    @test all(sort(collect(keys(cl1))) .== sort(collect(keys(cl1.expandMap))))
    @test all(minimal_set(cl1) .== sort(collect(keys(cl1.expandMap))))
end
