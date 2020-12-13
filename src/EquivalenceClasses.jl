struct EquivalenceClasses{T}
    f::Union{Predicate,Mapping}
    full::AbstractArray{T,1}
    classes::Dict{T,Int64}
end

# ====================  Auxiliary functions ====================

Base.show(io::IO, z::EquivalenceClasses) = show(io, "Equivalence Classes of $(z.f): "*string(z.classes))
