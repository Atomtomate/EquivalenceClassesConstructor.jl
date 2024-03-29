import Base: show, display, hash, ==, isequal, eltype, keys, values
import Base: iterate, length # Dict stuff

# ========== Mapping/Predicate =========

# TODO: limit types for arguments of f
struct Predicate
  f::Function
end

struct Mapping
  f::Function
end

"""
    Predicate(f)(x,y)
Functor definition for Predicate. This allows to use the type Predicate as a function that is guaranteed to 
have two arguments and return a Bool.
# Examples
```
Predicate((x,y) -> x>y)(3,4)
julia> true 
p = Predicate((x,y) -> x>y);
p(4,3)
julia> false 
```
"""
#((p::Predicate)(x::T, y::T)::Bool) where T = p.f(x,y)
##TODO: Documenter bug: the line above does not work for @autodocs
((p::Predicate)(x, y)::Bool) = p.f(x,y)

"""
    Mapping(f)(x,y)
Functor definition for Mapping. This allows to use the type Mapping as a function that is guaranteed to 
have two arguments and return a Bool.
# Examples
```
Mapping(x -> [x,2*x])(3)
julia> [3,6]
Mapping(x -> 2:x)(30)
julia> 2:30
```
"""
#((m::Mapping)(x::T)::AbstractArray{T,1}) where T = m.f(x)
##TODO: Documenter bug: the line above does not work for @autodocs
((m::Mapping)(x)) = m.f(x)

# ========== ReduceMap =========
"""
    ReduceMap

"""
struct ReduceMap{K, V} <: AbstractDict{K,V}
    map::OrderedDict{K,V}
    function ReduceMap(d::OrderedDict{K1,V1}) where {K1,V1}
        ReduceMap_TConstr(K1,V1)
        new{K1,V1}(d)
    end
end

function ReduceMap_TConstr(::Type{K}, ::Type{V}) where {K, V}
    if !((K === V) || ((V === UInt32) || (V === Int64) || (V == Tuple{UInt32, UInt32})))
        throw(TypeError(:ReduceMap,"Key and Value must have the same type, OR Value must be UInt32/Int64", Union{K,UInt32}, V))
     end
     return nothing
end

ReduceMap(args...) = ReduceMap(OrderedDict(args...))
ReduceMap{K,V}() where {K,V} = ReduceMap(OrderedDict{K,V}()) 

# ---------- Dict Wrapper  ---------
@forward ReduceMap.map (Base.show, Base.length, Base.iterate, Base.getindex, Base.setindex!)


# ---------- Auxiliary Functions  ---------

function toIndexMap(rm::ReduceMap{T,T}, orderedSet) where T
    res = ReduceMap{T,UInt32}()
    for (K,V) in rm
        res[K] = UInt32(findfirst(x->x==V, orderedSet))
    end
    return res
end

function toDirectMap(rm::ReduceMap{T,UInt32}, orderedSet) where T
    res = ReduceMap{T,T}()
    for (K,V) in rm
        res[K] = orderedSet[rm[K]]
    end
    return res
end



# ========== ExpandMap =========
"""
    ExpandMap(rm::ReduceMap [,sorted])

Constructs mapping from a set of representatives of classes to full set using 
a ReduceMap `rm`.
Each lit of mappings to the full can be ordered by setting `sorted`.
"""
struct ExpandMap{K,V <: Union{K, Int64, UInt32}}
    map::Dict{V,Array{K,1}}
    function ExpandMap(rm::ReduceMap{K1,V1}, orderedSet=nothing; sorted=false) where {K1,V1}
        if (V1 == UInt32 || V1 == Int64) && orderedSet != nothing 
            new{K1,K1}(invertDict(toDirectMap(rm, orderedSet).map, sorted=sorted))
        else
            new{K1,V1}(invertDict(rm.map, sorted=sorted))
        end
    end
end

# ---------- Dict Wrapper  ---------
@forward ExpandMap.map (Base.keys, Base.values, Base.show, Base.length, Base.iterate, Base.getindex, Base.setindex!)


# --------------------  Auxiliary functions --------------------

Base.hash(a::ExpandMap, h::UInt) = hash(a.map, hash(:ExpandMap, h))
Base.:(==)(a::ExpandMap{T}, b::Dict{T,Array{T,1}}) where T = (a.map == b)
Base.:(==)(a::ExpandMap, b::ExpandMap) = (a.map == b.map)


# ====================  Auxiliary functions ====================

function display(el::ExpandMap) 
    show(stdout, el)
end

function show(io::IO,el::ExpandMap) 
    show(io, "ExpandMap{$(eltype(el))}["*string(length(el.map))*"]:\n"*string(el.map))
end


minimal_set(m::ExpandMap; sorted=true) = sorted ? sort(collect(keys(m))) : collect(keys(m))
minimal_set(m::ReduceMap; sorted=true) = sorted ? sort(collect(unique(values(m)))) : collect(unique(values(m)))

"""
    labelsMap(m::ReduceMap)
Transforms values to set of continuous numbers.

# Examples
label(ReduceMap(1=>1, 2=>3, 3=>5))
julia> ReduceMap{Int64,Int64} with 3 entries:
  2 => 3
  3 => 5
  1 => 1
"""
function labelsMap(m::ReduceMap)::ReduceMap
    vv = unique(values(m))
    lookup = OrderedDict{keytype(m), UInt32}(zip(vv, 1:length(vv)))
    res = OrderedDict{keytype(m), UInt32}()
    for (k,v) in m
        res[k] = lookup[v]
    end
    return ReduceMap(res)
end
