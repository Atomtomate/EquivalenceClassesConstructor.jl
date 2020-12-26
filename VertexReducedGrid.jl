using Pkg
Pkg.activate(".")
using EquivalenceClassesConstructor
using Printf, DataStructures

const nBose = 80
const nFermi = 80
const shift = 0

# ===== Test with integers =====
println("Integer test")
const nB = UInt32(2*maximum((2*nFermi+shift*ceil(nBose/2),2*nBose+1))+1)
const nBh = floor(UInt32, nB/2)
nB^2 > typemax(UInt32) && throw(ArgumentError("nBose or nFermi too large for UInt32 operations."))
const nB2 = UInt32(nB*nB)
const nBm1 = UInt32(nB-1)
@fastmath @inline tripleToInt(i::UInt32, j::UInt32, k::UInt32)::UInt32 = UInt32(i*nB2 + j*nB + k)
@fastmath @inline tripleToInt(i::UInt32, j::UInt32, k::UInt32, offset::UInt32)::UInt32 = UInt32((i+offset)*nB2 + (j+offset)*nB + (k+offset))

function tripleToInt(i,j,k)
    return tripleToInt(UInt32(i), UInt32(j), UInt32(k))
end
tripleToInt(i,j,k,offset) = tripleToInt(i+offset,j+offset,k+offset)

const oobConst = tripleToInt(nB,0,0)

@fastmath @inline function intToTriple(::Type{T}, z::UInt32) where {T<:Integer}
    r,k = divrem(z,nB)
    i,j = divrem(r,nB)
    return (convert(T,i)-nBh,convert(T,j)-nBh,convert(T,k)-nBh)
end

intToTriple(z::UInt32) = intToTriple(Int64, z)

@fastmath @inline function reverseSymm(z::UInt32)
    r,k = divrem(z,nB)
    i,j = divrem(r,nB)
    return tripleToInt(UInt32(-i+nBm1), UInt32(-j+nBm1-1),UInt32(-k+nBm1-1))
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
    r1 = tripleToInt(ni, nj-UInt32(1), nk-UInt(1))
    r2 = tripleToInt(iu, ku, ju)
    r3 = oobConst
    r4 = oobConst
    r5 = oobConst
    if t2 < nB 
        if t1 < nB 
            r3 = tripleToInt(t1, ju, t2)
        end
        if t3 < nB
            r5 = tripleToInt(ni, t3, t2)
        end
    end
    if (t3 < nB && t4 < nB)
        r4 = tripleToInt(t4, t3, ku)
    end
    return r1,r2,r3,r4,r5
end


println("Constructing Array")
freqList = [(i,j,k) for i in (-nBose:nBose) for j in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2) for k in (-nFermi:nFermi-1) .- trunc(Int64,shift*i/2)]
const freqList_int = map(x->tripleToInt(x..., nBh), freqList)
const len_freq = (2*nBose+1)*(2*nFermi)^2

const mm_2 = Mapping(symm_map_int)
println("Starting Computation 3")
maxF = nBose + 2*nFermi + 5
headerstr= @sprintf("  %26d  \n", maxF)
@time cl_2 = find_classes(mm_2, freqList_int, vl_len=len_freq);
full_t = intToTriple.(Int64,freqList_int);
classes_t = Dict((map(el->[intToTriple(Int64,el[1]),el[2]], collect(cl_2.classes))));
cl_2_t = EquivalenceClasses(mm_2, classes_t);
println("testtest")
@time em_2 = ExpandMap(cl_2_t);
@time rm_2 = ReduceMap(cl_2_t, freqList)
#write_fixed_width("freqList_2.dat", em_2, sorted=true, header_add=headerstr);
write_JLD("freqList_2.jld", em_2, rm_2, cl_2)
