import Base: show, display, hash, ==, isequal, eltype

# ========== IndexMapping =========
struct IndexMapping{T}
    full::AbstractArray{T}
    expandMap::Dict{T,Array{T,1}}
end

Base.hash(a::IndexMapping, h::UInt) = hash(a.full, hash(a.expandMap, hash(:IndexMapping, h)))
Base.:(==)(a::IndexMapping{T}, b::Dict{T,Array{T,1}}) where T = (a.expandMap == b)
Base.:(==)(a::IndexMapping, b::IndexMapping) = (a.full == b.full) && (a.expandMap == b.expandMap)
Base.eltype(el::IndexMapping) = eltype(el.full)

function display(el::IndexMapping) 
    show(stdout, el)
end

function show(io::IO,el::IndexMapping) 
    show(io, "IndexMapping{$(eltype(el))}[Full: " * string(el.full)*", ExpandMap: "*string(el.expandMap)*"]")
end
