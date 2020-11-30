@testset "write fixed width" begin
    res1 = """# Reduced           Mapped To
-4                  [-4]
-3                  [-3, 3]
-2                  [-2, 2]
-1                  [-1, 1]
0                   [0]
"""
    io = IOBuffer()
    eqc = EquivalenceClasses(Mapping(x -> [-x]), -4:3, sorted=true)
    write_fixed_width(io, eqc)
    write_fixed_width(stdout, eqc)
    @test String(take!(io)) == res1 
end
