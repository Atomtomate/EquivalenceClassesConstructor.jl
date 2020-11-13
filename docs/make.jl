using EquivalenceClassesConstructor
using Documenter

makedocs(;
    modules=[EquivalenceClassesConstructor],
    authors="Julian Stobbe <Atomtomate@gmx.de> and contributors",
    repo="https://github.com/Atomtomate/EquivalenceClassesConstructor.jl/blob/{commit}{path}#L{line}",
    sitename="EquivalenceClassesConstructor.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://Atomtomate.github.io/EquivalenceClassesConstructor.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/Atomtomate/EquivalenceClassesConstructor.jl",
)
