function write_fixed_width(io::IO, minSet::Vector{Tuple{T, T, T}}; sorted=false, header_add=repeat(" ", 10)) where T
    length(header_add) != 10 && throw(ArgumentError("header string must be 10 characters long"))
    ll = sorted ? sort(minSet) : collect(minSet)
    @printf(io, "# === Header Start ===        \n")
    @printf(io, "    # of Elements             \n")
    @printf(io, "  %12d      %s\n", length(minSet), header_add)
    @printf(io, "# === Header End ===          \n")
    for k in ll
        @printf(io, " %9d %9d %9d\n", k...)
    end
end

function write_fixed_width(io::IO, minSet::Vector; sorted=false, header_add=repeat(" ", 10))
    length(header_add) != 10 && throw(ArgumentError("header string must be 10 characters long"))
    ll = sorted ? sort(minSet) : collect(minSet)
    write(io, "# === Header Start ===        \n")
    write(io, "    # of Elements             \n")
    write(io, rpad(" "*string(length(minSet))*" "*header_add, 30, " ")*"\n")
    write(io, "# === Header End ===          \n")
    for k in ll
        for ki in k
            write(io, rpad(k,10))
        end
        write(io, "\n")
    end
end


io_functions = (:write_fixed_width, )

# For all write functions f(io::IO, args...) generate wrappers f(args...) which writes
# directly to stdout and f(s::String, args...) which opens/closes a file and writes to it.
for ff in io_functions
    @eval $ff(s::String, arg, args...; kwargs...) = (open(s,"w") do io; $ff(io,arg,args...; kwargs...); end)
    @eval $ff(arg, args...; kwargs...) = $ff(stdout, arg, args...; kwargs...)
end
