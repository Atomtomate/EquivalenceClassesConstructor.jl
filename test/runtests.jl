using EquivalenceClassesConstructor
using Test

using Printf
using DataStructures
using JLD
include("../src/Types.jl")
include("../src/GraphTools.jl")
include("../src/helpers.jl")
include("../src/IO.jl")

@testset "EquivalenceClassesConstructor.jl" begin
    # Write your tests here.
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
