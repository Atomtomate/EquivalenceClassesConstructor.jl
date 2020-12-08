using Pkg
Pkg.activate(".")
using EquivalenceClassesConstructor

nBose = 3
nFermi = 3
shift = 1

function symm_pred(l::Tuple{Int64,Int64,Int64}, r::Tuple{Int64,Int64,Int64})
    res = (l .== .-r) || (l[1] == r[1] && l[2] == r[3] && l[3] == r[2]) || # complex conjugation and time reversal
    ((l[1] == r[2] + r[3]) && l[2] == r[2] && (l[3] == r[1] + r[2])) ||    # single crossing symmetry (creation)
    ((r[1] == l[2] + l[3]) && r[2] == l[2] && (r[3] == l[1] + l[2])) ||    #     ---  "  ---
    ((l[1] == r[3] - r[2]) && (l[2] == r[1] + r[3]) && l[3] == r[3]) ||    # single crossing symmetry (annihilation)
    ((r[1] == l[3] - l[2]) && (r[2] == l[1] + l[3]) && r[3] == l[3]) ||    #     ---  "  ---
    (r[1] == -l[1] && (l[2] == r[1] + r[3]) && (l[3] == r[1] + r[2])) ||   # double crossing
    (l[1] == -r[1] && (r[2] == l[1] + l[3]) && (r[3] == l[1] + l[2]))     #     ---  "  ---
    return res
end

function symm_map(t::Tuple{Int64,Int64,Int64})::Array{Tuple{Int64,Int64,Int64},1}
    res = [.- t .- (0,1,1), (t[1], t[3], t[2]),        # complex conjugation and time reversal
            (t[3]-t[2], t[2], t[1]+t[2]),    # single crossing (creation)
            (t[2]-t[3], t[1] + t[3], t[3]), #,  # single crossing (annihilation)
           (-t[1],t[1]+t[3], t[1] + t[2])]  # double crossing
end

freqList = [(i,j,k) for i in (-nBose:nBose) for j in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2) for k in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2)]

mm = Mapping(symm_map)
cl = find_classes(mm, freqList)
