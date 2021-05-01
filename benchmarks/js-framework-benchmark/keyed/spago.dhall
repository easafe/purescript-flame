{ name = "js-framework-benchmark-flame"
, dependencies = [
    "flame",
    "aff",
    "arrays",
    "effect",
    "maybe",
    "prelude" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
