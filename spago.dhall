{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "flame"
, license = "MIT"
, repository = "https://github.com/easafe/purescript-flame"
, dependencies =
  [ "aff"
  , "argonaut-codecs"
  , "argonaut-generic"
  , "console"
  , "debug"
  , "effect"
  , "foreign-object"
  , "integers"
  , "nullable"
  , "prelude"
  , "psci-support"
  , "random"
  , "record"
  , "signal"
  , "test-unit"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
