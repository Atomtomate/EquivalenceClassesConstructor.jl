function write_fixed_width(io::IO, em::ExpandMap; sorted=false, header_add=repeat(" ", 10))
    length(header_add) != 10 && throw(ArgumentError("header string must be 10 characters long"))
    ll = sorted ? sort(collect(keys(em.map))) : collect(keys(em.map))
    write(io, "# Reduced           Mapped To \n") 
    write(io, "# === Header Start ===        \n")
    write(io, "    # of Elements             \n")
    write(io, rpad(" "*string(length(em.map))*" "*header_add, 30, " ")*"\n")
    write(io, "# === Header End ===          \n")
    m = em.map
    for k in ll
        write(io, rpad(k,30)*string(m[k])*"\n")
    end
end


function write_fixed_width_3D(file::String, em::ExpandMap; sorted=false)
    open(file, "w") do f
        write_fixed_width_3D(f, em::ExpandMap, sorted=sorted)
    end
end

function write_fixed_width_3D(io::IO, em::ExpandMap; sorted=false, 
        header_add = repeat(" ", 10))
    length(header_add) != 10 && throw(ArgumentError("header string must be 10 characters long"))
    @printf(io, "  %12d      %s\n", length(em.map),header_add)
    @printf(io, "# === Header End ===          \n")
    for k in ll
        @printf(io, " %9d %9d %9d\n", k...)
    end
end

function write_JLD(fname::String, rm::ReduceMap, em::ExpandMap; bare=true)
    out = bare ? em.map : em
    save(fname, "ExpandMap", out, "ReduceMap", rm)
end

io_functions = (:write_fixed_width, :write_fixed_width_3D)

# For all write functions f(io::IO, args...) generate wrappers f(args...) which writes
# directly to stdout and f(s::String, args...) which opens/closes a file and writes to it.
for ff in io_functions
    @eval $ff(s::String, arg, args...; kwargs...) = (open(s,"w") do io; $ff(io,arg,args...; kwargs...); end)
    @eval $ff(arg, args...; kwargs...) = $ff(stdout, arg, args...; kwargs...)
end
