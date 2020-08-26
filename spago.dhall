{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "flame"
, license = "MIT"
, repository = "https://github.com/easafe/purescript-flame"
, dependencies =
  [ "aff"
  , "affjax"
  , "argonaut-codecs"
  , "argonaut-generic"
  , "console"
  , "debug"
  , "effect"
  , "foreign-object"
  , "httpure"
  , "integers"
  , "node-fs-aff"
  , "node-http"
  , "nullable"
  , "prelude"
  , "psci-support"
  , "random"
  , "record"
  , "websocket-simple"
  , "signal"
  , "test-unit"
  , "web-events"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs", "examples/**/*.purs" ]
}
