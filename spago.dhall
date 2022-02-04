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
  , "argonaut-core"
  , "argonaut-generic"
  , "arrays"
  , "bifunctors"
  , "console"
  , "effect"
  , "either"
  , "exceptions"
  , "foldable-traversable"
  , "foreign"
  , "foreign-object"
  , "maybe"
  , "newtype"
  , "nullable"
  , "partial"
  , "prelude"
  , "psci-support"
  , "random"
  , "refs"
  , "strings"
  , "test-unit"
  , "tuples"
  , "typelevel-prelude"
  , "unsafe-coerce"
  , "web-dom"
  , "web-events"
  , "web-html"
  , "web-uievents"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
