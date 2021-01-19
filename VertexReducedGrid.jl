using Pkg
Pkg.activate(".")
using EquivalenceClassesConstructor
using Printf, DataStructures
using JLD

include("../vertexIntTriple.jl")

const nBose = 100
const nFermi = 100
const shift = 0

# ===== Test with integers =====
println("Integer test")
const nB = UInt32(2*maximum((2*nFermi+shift*ceil(nBose/2),2*nBose+1))+1)
const nBh = floor(UInt32, nB/2)
(nB^2 > typemax(UInt32)) && throw(ArgumentError("nBose or nFermi too large for UInt32 operations."))
const nB2 = UInt32(nB*nB)
const nBm1 = UInt32(nB-1)
const oobConst = tripleToInt(nB,0,0,nB,nB2)

@fastmath @inline function reverseSymm(z::UInt32)
    r,k = divrem(z,nB)
    i,j = divrem(r,nB)
    return tripleToInt(UInt32(-i+nBm1), UInt32(-j+nBm1-1),UInt32(-k+nBm1-1),nB,nB2)
end

@fastmath @inline function symm_map_int(z::UInt32)
    r,k = divrem(z,nB)
    i,j = divrem(r,nB)
    iu = UInt32(i)
    ju = UInt32(j)
    ku = UInt32(k)
    ni = UInt32(-i+nBm1)
    nj = UInt32(-j+nBm1)
    nk = UInt32(-k+nBm1)
    t1 = ku+nj-nBh #i and j both contain nBh, we need to subtract the double shift
    t2 = iu+ju-nBh
    t3 = iu+ku-nBh
    t4 = ju+nk-nBh
    r1 = tripleToInt(ni, nj-UInt32(1), nk-UInt(1),nB,nB2) # c.c.: Op 2 (*)
    r2 = tripleToInt(iu, ku, ju,nB,nB2)                   # time reversal: Op 1 (1)
    r3 = oobConst                                         # double Crossing: Op 1 (1)
    r4 = oobConst                                         # crossing c: Op 3 (-)
    r5 = oobConst                                         # crossing c^t: Op 3 (-) 
    if t2 < nB 
        if t1 < nB 
            r3 = tripleToInt(t1, ju, t2,nB,nB2)
        end
        if t3 < nB
            r5 = tripleToInt(ni, t3, t2,nB,nB2)
        end
    end
    if (t3 < nB && t4 < nB)
        r4 = tripleToInt(t4, t3, ku,nB,nB2)
    end
    return r1,r2,r3,r4,r5
end


println("Constructing Array")
freqList = [(i,j,k) for i in (-nBose:nBose) for j in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2) for k in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2)]
const freqList_int = map(x->tripleToInt(x..., nBh,nB,nB2), freqList)
const len_freq = (2*nBose+1)*(2*nFermi)^2

const mm_2 = Mapping(symm_map_int)
println("Starting Computation 3")
maxF = nBose + 2*nFermi + 5
headerstr= @sprintf("%10d", maxF)
#@time redMap_ui = find_classes(mm_2, freqList_int, vl_len=len_freq);
#@time redMap = labelsMap(redMap_ui)
#@time expMap = ExpandMap(redMap);

#@time redMap_ui = find_classes(mm_2, freqList_int, vl_len=len_freq);
#@time redMap = labelsMap(redMap_ui)
#@time expMap = ExpandMap(redMap);
#@time redMap_tri = ReduceMap((map(el->[intToTriple(Int64,el[1]),el[2]], collect(redMap.map))));
#@time expMap_tri = ExpandMap(redMap_tri)
#@time rm_2 = toDirectMap(ReduceMap(classes_t), freqList);
@time parents, ops = find_classes(mm_2.f, freqList_int, UInt32.([2, 1, 1, 3, 3]), vl_len=len_freq);
#write_fixed_width("freqList_tri.dat", expMap_tri, sorted=true, header_add=headerstr);
#write_JLD("freqList_2.jld", rm_2, expMap)
#save("freqList.jld", "ExpandMap", expMap, "ReduceMap", redMap, "base", nB, "nFermi", 2*nFermi, "nBose", 2*nBose+1, "shift", shift, "offset", nBh)
save("freqList_new.jld", "parents", parents, "ops", ops, "base", nB, "nFermi", 2*nFermi, "nBose", 2*nBose+1, "shift", shift, "offset", nBh)
