using Documenter
using PrettyTables

makedocs(
    modules = [PrettyTables],
    format = Documenter.HTML(
        prettyurls = !("local" in ARGS),
        canonical = "https://ronisbr.github.io/PrettyTables.jl/stable/",
    ),
    sitename = "Pretty Tables",
    authors = "Ronan Arraes Jardim Chagas",
    pages = [
        "Home"               => "index.md",
        "Usage"              => "man/usage.md",
        "Back-ends"          => Any[
            "Text"           => "man/text_backend.md",
            "HTML"           => "man/html_backend.md",
        ],
        "Alignment"          => "man/alignment.md",
        "Filters"            => "man/filters.md",
        "Formatters"         => "man/formatter.md",
        "Examples"           => Any[
            "Text back-end"  => "man/text_examples.md",
            "HTML back-end"  => "man/html_examples.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/ronisbr/PrettyTables.jl.git",
    target = "build",
)
