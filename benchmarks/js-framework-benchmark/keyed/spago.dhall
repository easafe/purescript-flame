{ name = "js-framework-benchmark-flame"
, dependencies =
  [ "aff"
  , "arrays"
  , "effect"
  , "flame"
  , "maybe"
  , "prelude"
  , "tuples"
  , "web-dom"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
, backend = "npx purs-backend-es build"
}
