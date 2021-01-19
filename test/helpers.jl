@testset "InvertDict" begin
    @test invertDict(OrderedDict()) == OrderedDict()
    @test invertDict(OrderedDict(0 => 1, 2 => 3)) == OrderedDict(1 => [0], 3 => [2])
    @test invertDict(OrderedDict(0 => 1, 2 => 3, 3 => 3)) == OrderedDict(1 => [0], 3 => [2])
end

@testset "Labels" begin
    @test sort(collect(values(labelsMap(cl1)))) == UInt32.(1:length(cl1))
    @test sort(collect(values(labelsMap(cl2)))) == UInt32.([1,1,2,2,3,3,4,5,6])
end
