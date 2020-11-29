function write_fixed_width(io::IO, eqc::EquivalenceClasses)
    write(io, "# Reduced           Mapped To\n") 
    for (k,v) in eqc.map.expandMap
        write(io, rpad(k,20)*string(v)*"\n")
    end
end
