using EquivalenceClassesConstructor
using Test

using Printf
using DataStructures
using JLD
include("../src/Mappings.jl")
include("../src/EquivalenceClasses.jl")
include("../src/Types.jl")
include("../src/helpers.jl")
include("../src/GraphTools.jl")
include("../src/IO.jl")

@testset "EquivalenceClassesConstructor.jl" begin
    # Write your tests here.
    @testset "helpers" begin
        include("./helpers.jl")
    end
    @testset "Types" begin
        include("./Types.jl")
    end
    @testset "predicates" begin
        include("./Mappings.jl")
    end
    @testset "graph" begin
        include("./GraphTools.jl")
        include("./EquivalenceClasses.jl")
    end
    @testset "IO" begin
        include("./IO.jl")
    end
end
