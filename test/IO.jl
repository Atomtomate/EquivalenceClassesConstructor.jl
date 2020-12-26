@testset "write fixed width" begin
    res1 = """# Reduced           Mapped To 
# === Header Start ===        
    # of Elements             
30   
                              
# === Header End ===          
-4                            Int64[]
-3                            [3]
-2                            [2]
-1                            [1]
0                             Int64[]
"""
    io = IOBuffer()
    cl = find_classes(Mapping(x -> [-x]), -4:3)
    em = ExpandMapping(cl, collect(-4:3))
    write_fixed_width(io, em, sorted=true)
    @test String(take!(io)) == res1 
end

@testset "JLD" begin
    io = IOBuffer()
    cl = find_classes(Mapping(x -> [-x]), -4:3)
    em = ExpandMapping(cl, collect(-4:3))
    write_JLD("tmp_save.jld", em, cl)
    d = load("tmp_save.jld")
    @test em == d["ExpandMap"]
    rm("tmp_save.jld")
end
