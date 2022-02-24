Equivalence Classes Constructor
===========

This Project aims to provide a tool package that can construct equivalence classes from symmetry predicates over
a given set or mappings between elements.
The reason being that subsequent calculations may be sped up by only considering one representative of each
equivalence class.

This code contains collection of methods that are able to construct mappings between full and reduced sets. 
Specifically, for any indices `x, y` in some given set `vl` the known symmetries are given as input in the 
form of predicates, i.e. `p(x,y)` &#8712; `{true, false}` or in form of mappings `m(x) = y`.
The latter greatly increases performance but may lead to unexpected behavior with non monotonic mappings<sup>[1](#footnote1)</sup>. 
As result, the original set `vl` is supplemented with a reduced set `vl_red` and a mapping `expand_vl` which
can be used to expand subsequent calculations over the reduced set back to the full one.


|     Build Status    |      Coverage      |  Documentation |      Social    |
| ------------------- |:------------------:| :-------------:| :-------------:|
| [![Build Status](https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/workflows/CI/badge.svg)](https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/actions) | [![Coverage](https://codecov.io/gh/Atomtomate/EquivalenceClassesConstructor.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Atomtomate/EquivalenceClassesConstructor.jl) | [![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://Atomtomate.github.io/EquivalenceClassesConstructor.jl/stable) |[![Gitter](https://badges.gitter.im/JuliansBastelecke/EquivalenceClasses.svg)](https://gitter.im/JuliansBastelecke/EquivalenceClasses?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge) |


Setup
-----------




Basic Usage
-----------

By default, the constructor of the `EquivalenceClasses` will do the heavy lifting. You should therefore expect 
this line of the code to use up substential amount of compute time for large inputs.
The first step is to define a seg `S` and a relationship between elements of `S`.

```
using EquivalenceClassesConstructor

S = -4:3
m1 = Mapping(x -> [-x])
p1 = Predicate((x,y) -> x == -y)
```
In cases where a mapping is known, it should be prefered over predicates since it requires substantially less evaluation time.
Once the relationships and grid are defined we can compute a minimal set of representatives from all equivalence classes of `S`
under `m1` or `p1`.
```
eqc = EquivalenceClasses(m1, S)
eqc_2 = EquivalenceClasses(p1, S)
```
Both computations should yield a minimal set and a mapping back to `S`.
Ordering is not guaranteed, but can be forced by adding the optional parameter `sorted=true` to the `EquivalenceClasses`
constructor.

Since the output is most likely part of a larger computation, the package provides some IO options. For example as fixed width
human readable files.
```
open("eqc_out.txt", "w") do io
    write_fixed_width(io, eqc)
end;
```

Examples
-----------

`VertexReducedGrid.jl` constructs a minimal set for the input vertex of ['LadderDGA.jl'](https://github.com/Atomtomate/LadderDGA.jl). 


<a name="footnote1">1</a>: The reason being, that `m(m(x))` may lie in `vl` but `m(x))` may not, forcing the algorithm to terminate.
