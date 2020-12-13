module EquivalenceClassesConstructor

using DataStructures, Printf
export Predicate, Mapping, ExpandMapping, EquivalenceClasses, find_classes, minimal_set
export write_fixed_width


  include("./Mappings.jl")
  include("./EquivalenceClasses.jl")
  include("./GraphTools.jl")
  include("./Types.jl")
  include("./helpers.jl")
  include("./IO.jl")
# Write your package code here.

end
