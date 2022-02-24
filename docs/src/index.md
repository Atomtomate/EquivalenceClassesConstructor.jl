```@meta
CurrentModule = EquivalenceClassesConstructor
```

# EquivalenceClassesConstructor
This code aims to provide a collection of methods that are able to exploit
symmetries in arbitrary indexable objects over a given index set `vl`.
For any indices `x, y` these symmetries must be known in the form of predicates, 
i.e. `p(x,y) &#8712; {true, false}` or in form of mappings `m(x) = y`.
The latter greatly increases performance but may lead to unexpected behavior
with non monotonic mappings. The reason being that `m(m(x))` may lie in `vl`
but `m(x))` may not, forcing the algorithm to terminate.


# Index
```@index
```

```@autodocs
Modules = [EquivalenceClassesConstructor]
```
