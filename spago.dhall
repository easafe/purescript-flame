{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "flame"
, dependencies =
  [ "aff"
  , "argonaut-codecs"
  , "argonaut-generic"
  , "console"
  , "debug"
  , "effect"
  , "foreign-object"
  , "integers"
  , "node-http"
  , "nullable"
  , "prelude"
  , "psci-support"
  , "random"
  , "record"
  , "signal"
  , "test-unit"
  , "web-events"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
