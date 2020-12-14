function write_fixed_width(io::IO, em::ExpandMapping; sorted=false, header_add=repeat(" ", 30)*"\n")
    ll = sorted ? collect(keys(sort(em.map))) : collect(keys(em.map))
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

write_fixed_width(em::ExpandMapping; sorted=false) = write_fixed_width(stdout, em, sorted=sorted)


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
