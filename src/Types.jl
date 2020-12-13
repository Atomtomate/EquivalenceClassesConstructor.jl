import Base: show, display, hash, ==, isequal, eltype, keys

# ========== ExpandMapping =========
struct ExpandMapping{T}
    map::Dict{T,Array{T,1}}
end

"""
    ExpandMapping(vl::AbstractArray{T,1}, classes::Dict{T,Int64}, sorted=false) where T

Constructs mapping from a set of representatives of classes to full set using `vl` for full
set and a dict `classes` with mapping for each element of `vl` to its class.
"""
function ExpandMapping(vl::AbstractArray{T,1}, classes::Dict{T,Int64}; sorted=false) where T
    full_vals = (vl[i] for i in values(classes))
    fullDict = Dict{T,T}(zip(keys(classes),full_vals))
    expandMap = invertDict(fullDict, sorted=sorted)
    return ExpandMapping(expandMap)
end

ExpandMapping(eqc::EquivalenceClasses{T}; sorted=false) where T = ExpandMapping(eqc.full, eqc.classes, sorted=sorted)

Base.hash(a::ExpandMapping, h::UInt) = hash(a.map, hash(:ExpandMapping, h))
Base.:(==)(a::ExpandMapping{T}, b::Dict{T,Array{T,1}}) where T = (a.map == b)
Base.:(==)(a::ExpandMapping, b::ExpandMapping) = (a.map == b.map)

function display(el::ExpandMapping) 
    show(stdout, el)
end

function show(io::IO,el::ExpandMapping) 
    show(io, "ExpandMapping{$(eltype(el))}["*string(length(el.map))*"]:\n"*string(el.map))
end

keys(m::ExpandMapping) = keys(m.map)
minimal_set(m::ExpandMapping, sorted=true) = sorted ? sort(collect(keys(m))) : collect(keys(m))
