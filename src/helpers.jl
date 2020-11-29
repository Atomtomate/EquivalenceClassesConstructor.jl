function invertDict(D::Dict)
    uniqueV = unique(values(D))
    invD = Dict{keytype(D),Array{valtype(D),1}}(e => Array{valtype(D),1}() for e  in uniqueV)
    for (k,v) in D
        push!(invD[v], k)
    end
    return invD
end
