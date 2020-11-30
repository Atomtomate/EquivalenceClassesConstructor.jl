function invertDict(D::Dict; sorted=false)
    uniqueV = unique(values(D))
    invD = Dict{keytype(D),Array{valtype(D),1}}(e => Array{valtype(D),1}() for e  in uniqueV)
    for (k,v) in D
        push!(invD[v], k)
    end
    if sorted
        kl = collect(keys(invD))
        for k in sort!(kl)
            sort!(invD[k]) 
        end
    end
    return invD
end
