module EquivalenceClassesConstructor

using DataStructures, Printf, JLD, StaticArrays, Lazy
export Predicate, Mapping, ReduceMap, ExpandMap, EquivalenceClasses, find_classes, minimal_set
export toDirectMap, toIndexMap, labelsMap, minimal_set
export write_fixed_width, write_JLD


  include("./Types.jl")
  include("./GraphTools.jl")
  include("./helpers.jl")
  include("./IO.jl")

end
