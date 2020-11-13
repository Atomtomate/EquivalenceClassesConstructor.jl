using EquivalenceClassesConstructor
using Test

include("../src/predicate.jl")
include("../src/EquivalenceClasses.jl")

@testset "EquivalenceClassesConstructor.jl" begin
    # Write your tests here.
    @testset "predicates" begin
        include("./predicate.jl")
    end
    @testset "graph" begin
        include("./EquivalenceClasses.jl")
    end
end
