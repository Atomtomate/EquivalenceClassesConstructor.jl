using Pkg
Pkg.activate(".")
using EquivalenceClassesConstructor
using Printf

const nBose = 80
const nFermi = 80
const shift = 0


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

@inline function symm_map(t::Tuple{Int64,Int64,Int64})::Array{Tuple{Int64,Int64,Int64},1}
    res = [.- t .- (0,1,1), (t[1], t[3], t[2]),        # complex conjugation and time reversal
           (t[3]-t[2], t[2], t[1]+t[2]),    # single crossing (creation)
           (t[2]-t[3], t[1] + t[3], t[3]), #,  # single crossing (annihilation)
           (-t[1],t[1]+t[3], t[1] + t[2])]  # double crossing
end

println("Constructing Array")
const freqList = [(i,j,k) for i in (-nBose:nBose) for j in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2) for k in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2)]
const len_freq = (2*nBose+1)*(2*nFermi)^2
const mm = Mapping(symm_map)
println("Starting Computation 2")
maxF = nBose + 2*nFermi + 5
headerstr= @sprintf("  %26d  \n", maxF)
@time cl = find_classes(mm, freqList, vl_len=len_freq)
@time em = ExpandMapping(cl)
#write_fixed_width("freqList.dat", em, sorted=true, header_add=headerstr)
#write_JLD("freqList.jld", em, cl)


