using EquivalenceClassesConstructor
using Documenter

push!(LOAD_PATH, "../src/")
makedocs(;
    modules=[EquivalenceClassesConstructor],
    authors="Julian Stobbe <Atomtomate@gmx.de> and contributors",
    repo="https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/blob/{commit}{path}#L{line}",
    sitename="Equivalence Classes",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", nothing) == "true",
        canonical="https://Atomtomate.github.io/EquivalenceClassesConstructor.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    branch="gh-pages",
    devbranch = "main",
    devurl = "stable",
    repo="github.com/Atomtomate/EquivalenceClassesConstructor.jl.git",
)
