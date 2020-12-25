function write_fixed_width(io::IO, em::ExpandMapping; sorted=false, header_add=repeat(" ", 30)*"\n")
    ll = sorted ? sort(collect(keys(em.map))) : collect(keys(em.map))
    write(io, "# Reduced           Mapped To \n") 
    write(io, "# === Header Start ===        \n")
    write(io, "    # of Elements             \n")
    write(io, rpad(30,length(em.map))*"\n")
    write(io, header_add)
    write(io, "# === Header End ===          \n")
    m = em.map
    for k in ll
        write(io, rpad(k,30)*string(m[k])*"\n")
    end
end


function write_fixed_width_3D(file::String, em::ExpandMapping; sorted=false)
    open(file, "w") do f
        write_fixed_width_3D(f, em::ExpandMapping, sorted=sorted)
    end
end

function write_fixed_width_3D(io::IO, em::ExpandMapping; sorted=false, 
        header_add = repeat(" ", 30)*"\n")
    ll = sorted ? collect(keys(sort(em.map))) : collect(keys(em.map))
    @printf(io, "# Reduced           Mapped To \n") 
    @printf(io, "# === Header Start ===        \n")
    @printf(io, "    # of Elements             \n")
    @printf(io, "  %12d                \n", length(em.map))
    @printf(io, "%s", header_add)
    @printf(io, "# === Header End ===          \n")
    for k in ll
        @printf(io, " %9d %9d %9d\n", k...)
    end
end

function write_JLD(fname::String, em::ExpandMapping, cl::EquivalenceClasses; bare=true)
    out = bare ? em.map : em
    out2 = Dict(zip(keys(cl.classes),cl.full))
    save(fname, "ExpandMap", out, "ReduceMap", out2)
end

io_functions = (:write_fixed_width, :write_fixed_width_3D)

# For all write functions f(io::IO, args...) generate wrappers f(args...) which writes
# directly to stdout and f(s::String, args...) which opens/closes a file and writes to it.
for ff in io_functions
    @eval $ff(s::String, arg, args...; kwargs...) = (open(s,"w") do io; $ff(io,arg,args...; kwargs...); end)
    @eval $ff(arg, args...; kwargs...) = $ff(stdout, arg, args...; kwargs...)
end
