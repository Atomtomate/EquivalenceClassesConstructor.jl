# Equivalence Classes Constructor
This Project aims to provide a tool package that can construct equivalence classes from symmetry predicates over
a given set or mappings between elements.
The reason being that subsequent calculations may be sped up by only considering one representative of each
equivalence class.

This code contains collection of methods that are able to construct mappings between full and reduced sets. 
Specifically, for any indices `x, y` in some given set `vl` the known symmetries are given as input in the 
form of predicates, i.e. `p(x,y) &#8712; {true, false}` or in form of mappings `m(x) = y`.
The latter greatly increases performance but may lead to unexpected behavior with non monotonic mappings[^1]. 
As result, the original set `vl` is supplemented with a reduced set `vl_red` and a mapping `expand_vl` which
can be used to expand subsequent calculations over the reduced set back to the full one.


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Atomtomate.github.io/EquivalenceClassesConstructor.jl/stable)
[![Build Status](https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/workflows/CI/badge.svg)](https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/actions)
[![Coverage](https://codecov.io/gh/Atomtomate/EquivalenceClassesConstructor.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Atomtomate/EquivalenceClassesConstructor.jl) [![Join the chat at https://gitter.im/JuliansBastelecke/EquivalenceClasses](https://badges.gitter.im/JuliansBastelecke/EquivalenceClasses.svg)](https://gitter.im/JuliansBastelecke/EquivalenceClasses?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)


[^1]: The reason being, that `m(m(x))` may lie in `vl` but `m(x))` may not, forcing the algorithm to terminate.
