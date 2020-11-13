using EquivalenceClassesConstructor
using Test

@testset "EquivalenceClassesConstructor.jl" begin
    # Write your tests here.
    @testset "predicates" begin
        include("./predicate.jl")
    end
end
