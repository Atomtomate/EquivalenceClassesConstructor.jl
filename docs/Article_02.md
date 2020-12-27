# defining custom types

In order to have a cleaner code base, we will define a number of custom types that behave like built in types in most cases.
Specifically, we will wrap predicates/mappings as 
```
struct Predicate
  f::Function
end
struct Mapping
  f::Function
end

((p::Predicate)(x::T, y::T)::Bool) where T = p.f(x,y)
((m::Mapping)(x::T)::AbstractArray{T,1}) where T = m.f(x)
```
Where the last two lines allow us to use the `Predicate` and `Mapping` types as functions (types like that are usually called functors).
Note, that the syntax is a shorthand version of
```
function (p::Predicate)(x::T, y::T)::Bool where T 
  return p.f(x,y)
end
```

We can use such a functor in the following way, providing some flexibility over the return type, due to `AbstractArray`:
```
m1 = Mapping(x -> [x,2*x]);
m2 = Mapping(x -> 10:x);
m1(3)
julia> [3,6]
m1(4)
julia> [4,8]
m2(20)
julia> 10:20
```
The type definitions 

This will grant us two advantages:
  - we can attach addional information to such an object 
  - we can distinguish a mapping/predicate from any ordinary function

We will ignore the first point for now and come back to this point later.

A more involved step is the definition of maps. These will store information of the classes obtained by our algorithms in a convenient way.
We can distinguish two types of mappings over a given set $V$ and an associated `Predicate` or `Mapping` which can be constructed from the classes.
For performance reasons we will give the option to assume $V$ to be ordered and map to indices of $V$ instead of elements.
Therefore each $\mathcal{M} \to V$ and $V \to \mathcal{M}$ also has an overloaded function with $\mathcal{M} \to \mathbb{N}_{>0}$ and $\mathbb{N}_{>0} \to \mathbb{M}$  
  - `ReduceMap` maps each element of $V$ to one representative of $V$  (or an indices of $V$)
  - `ExpandMap` maps each representative of `ReduceMap` back to a list of all elements of $V$ in the same class

While mathematically straight forward, there are some interesting concepts for our Julia implementation which I want to discuss here.
Both maps should behave like hashmaps (i.e. `Dict`) in the rest of the program but have some additional convenience functions, primarily in the form of constructors.
Most information about the Julia features can be found in the [Constructor](https://docs.julialang.org/en/v1/manual/constructors/) and [Interface](https://docs.julialang.org/en/v1/manual/interfaces/) section of the manual.

