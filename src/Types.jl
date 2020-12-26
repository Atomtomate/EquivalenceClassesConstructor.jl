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

# ========== ReduceMap =========
const ReduceMap{T} = Dict{T,T}

function ReduceMap(classes::Dict{T,UInt32}, vl::Array{T,1}) where T
    res = ReduceMap{T}()
    for el in vl
        res[el] = vl[classes[el]]
    end
    return res
end

ReduceMap(eqc::EquivalenceClasses{T}, vl::Array{T,1}) where T = ReduceMap(eqc.classes, vl)

# ========== ExpandMap =========
struct ExpandMap{T1,T2}
    map::Dict{T1,Array{T2,1}}
end

"""
    ExpandMap(vl::AbstractArray{T,1}, classes::Dict{T,Int64}, sorted=false) where T

Constructs mapping from a set of representatives of classes to full set using 
a dict `classes` with mapping for each element of `vl` to its class.
"""
function ExpandMap(classes::Dict{T,UInt32}, vl::Array{T,1}; sorted=false, indexMap=false) where T
    inp = indexMap ? classes : Dict{T,T}()
    if !indexMap
        for (k,v) in classes
            inp[k] = vl[v]
        end
    end
    expandMap = invertDict(inp, sorted=sorted)
    return ExpandMap(expandMap)
end

ExpandMap(classes::Dict{T,UInt32}; sorted=false) where T = ExpandMap(invertDict(classes, sorted=sorted))
ExpandMap(eqc::EquivalenceClasses{T}; sorted=false) where T = ExpandMap(eqc.classes, sorted=sorted)
ExpandMap(eqc::EquivalenceClasses{T}, vl::Array{T,1}; sorted=false, indexMap=false) where T = ExpandMap(eqc.classes, vl, sorted=sorted, indexMap=indexMap)


# --------------------  Auxiliary functions --------------------

Base.show(io::IO, z::EquivalenceClasses) = show(io, "Equivalence Classes of $(z.f): "*string(z.classes))
Base.hash(a::ExpandMap, h::UInt) = hash(a.map, hash(:ExpandMap, h))
Base.:(==)(a::ExpandMap{T}, b::Dict{T,Array{T,1}}) where T = (a.map == b)
Base.:(==)(a::ExpandMap, b::ExpandMap) = (a.map == b.map)

function display(el::ExpandMap) 
    show(stdout, el)
end

function show(io::IO,el::ExpandMap) 
    show(io, "ExpandMap{$(eltype(el))}["*string(length(el.map))*"]:\n"*string(el.map))
end

keys(m::ExpandMap) = keys(m.map)
minimal_set(m::ExpandMap; sorted=true) = sorted ? sort(collect(keys(m))) : collect(keys(m))
