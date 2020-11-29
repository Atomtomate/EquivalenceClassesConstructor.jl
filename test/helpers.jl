@testset "InvertDict" begin
    @test invertDict(Dict()) == Dict()
    @test invertDict(Dict(0 => 1, 2 => 3)) == Dict(1 => [0], 3 => [2])
    @test invertDict(Dict(0 => 1, 2 => 3, 3 => 3)) == Dict(1 => [0], 3 => [2,3])
end
