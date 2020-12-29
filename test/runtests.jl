using EquivalenceClassesConstructor
using Test

using Printf
using DataStructures
using JLD
using Lazy
include("../src/Types.jl")
include("../src/GraphTools.jl")
include("../src/helpers.jl")
include("../src/IO.jl")


pred1 = Predicate((x,y) -> x == y)
pred2 = Predicate((x,y) -> x != y)
pred3 = Predicate((x,y) -> all(x .== -y)) 
pred4 = Predicate((x,y) -> x == y+3) 

m1 = Mapping(x -> [x])
m2 = Mapping(x -> [-x])
vl1 = collect(1:5)
vl2 = collect(-3:5)
cl1 = find_classes(m1, vl1)
cl2 = find_classes(m2, vl2)
cl2_res_index  = Dict(3 => UInt32(1), -3 => UInt32(1), 2 => UInt32(2), -2=> UInt32(2), 1 => UInt32(3), -1 => UInt32(3), 0 => UInt32(4), 4 => UInt32(8), 5 => UInt32(9))
cl2_res_direct = Dict(3 => -3, -3 => -3, 2 => -2, -2=>-2, 1 => -1, -1 => -1, 0 => 0, 4 => 4, 5 => 5)

@testset "EquivalenceClassesConstructor.jl" begin
    @testset "helpers" begin
        include("./helpers.jl")
    end
    @testset "Types" begin
        include("./Types.jl")
    end
    @testset "graph" begin
        include("./GraphTools.jl")
    end
    @testset "IO" begin
        include("./IO.jl")
    end
end
