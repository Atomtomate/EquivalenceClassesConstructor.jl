function write_fixed_width(io::IO, eqc::EquivalenceClasses)
    write(io, "# Reduced           Mapped To\n") 
    m = eqc.map.expandMap
    kl = collect(keys(m))
    sort!(kl)
    for k in kl
        write(io, rpad(k,20)*string(m[k])*"\n")
    end
end
