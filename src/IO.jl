function write_fixed_width(io::IO, em::ExpandMapping)
    write(io, "# Reduced           Mapped To\n") 
    m = em.map
    kl = collect(keys(m))
    sort!(kl)
    for k in kl
        write(io, rpad(k,20)*string(m[k])*"\n")
    end
end

write_fixed_width(em::ExpandMapping; sorted=false) = write_fixed_width(stdout, em, sorted=sorted)

function write_fixed_width(file::String, em::ExpandMapping; sorted=false)
    open(file, "w") do f
        write_fixed_width(f, em::ExpandMapping, sorted=sorted)
    end
end

function write_fixed_width(io::IO, em::ExpandMapping; sorted=false)
    write(io, "# Reduced           Mapped To\n") 
    @printf(io, "# === Header Start ===        \n")
    @printf(io, "    # of Elements             \n")
    @printf(io, "  %12d                \n", length(em.map))
    @printf(io, "# === Header End ===          \n")
    ll = sorted ? keys(sort(em.map)) : keys(em.map)
    for k in ll
        @printf(io, " %9d %9d %9d\n", k...)
    end
end
