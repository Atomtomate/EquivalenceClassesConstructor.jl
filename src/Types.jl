import Base: show, display, hash, ==, isequal, eltype, keys


# ========== Mapping/Predicate =========

# TODO: limit types for arguments of f
struct Predicate
  f::Function
end

struct Mapping
  f::Function
end

(p::Predicate)(x,y) = p.f(x,y)
(m::Mapping)(x) = m.f(x)


# ========== EquivalenceClasses =========

struct EquivalenceClasses{T}
    f::Union{Predicate,Mapping}
    classes::Dict{T,UInt32}
end

# ========== ExpandMapping =========
struct ExpandMapping{T1,T2}
    map::Dict{T1,Array{T2,1}}
end

"""
    ExpandMapping(vl::AbstractArray{T,1}, classes::Dict{T,Int64}, sorted=false) where T

Constructs mapping from a set of representatives of classes to full set using 
a dict `classes` with mapping for each element of `vl` to its class.
"""
function ExpandMapping(classes::Dict{T,UInt32}, vl::Array{T,1}; sorted=false, indexMapping=false) where T
    inp = indexMapping ? classes : Dict{T,T}(zip(keys(classes),keys(classes)))
    if !indexMapping
        for (k,v) in classes
            inp[k] = vl[v]
        end
    end
    expandMap = invertDict(inp, sorted=sorted)
    return ExpandMapping(expandMap)
end

ExpandMapping(classes::Dict{T,UInt32}; sorted=false) where T = ExpandMapping(invertDict(classes, sorted=sorted))
ExpandMapping(eqc::EquivalenceClasses{T}; sorted=false) where T = ExpandMapping(eqc.classes, sorted=sorted)
ExpandMapping(eqc::EquivalenceClasses{T}, vl::Array{T,1}; sorted=false, indexMapping=false) where T = ExpandMapping(eqc.classes, vl, sorted=sorted, indexMapping=indexMapping)


# --------------------  Auxiliary functions --------------------

Base.show(io::IO, z::EquivalenceClasses) = show(io, "Equivalence Classes of $(z.f): "*string(z.classes))

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
minimal_set(m::ExpandMapping; sorted=true) = sorted ? sort(collect(keys(m))) : collect(keys(m))
