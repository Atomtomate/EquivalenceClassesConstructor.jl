@testset "write fixed width" begin
    res1 = """# Reduced           Mapped To
0                   [0]
-4                  [-4]
-3                  [-3, 3]
-2                  [2, -2]
-1                  [-1, 1]
"""
    io = IOBuffer()
    eqc = EquivalenceClasses(Mapping(x -> [-x]), -4:3)
    write_fixed_width(io, eqc)
    @test String(take!(io)) == res1 
end
