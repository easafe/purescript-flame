{ name = "js-framework-benchmark-flame"
, dependencies = [ "flame",
    "aff",
    "arrays",
    "effect",
    "maybe",
    "web-dom",
    "prelude" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
