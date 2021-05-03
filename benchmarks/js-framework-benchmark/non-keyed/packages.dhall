let upstream =
    https://github.com/purescript/package-sets/releases/download/psc-0.14.1-20210427/packages.dhall sha256:edbb8f70232fb83895c7ce02f5d2b29f6ee1722f1a70fc58d3bc0ab0de18afe4


let overrides = { = }

let additions = {
    flame =
        { dependencies =
            [ "prelude",
              "console",
              "effect",
              "web-events",
              "web-dom",
              "web-html",
              "nullable",
              "aff",
              "foreign-object",
              "argonaut-generic"
            ]
            , repo =
                "https://github.com/easafe/purescript-flame.git"
            , version =
                "b139dca847f32968aaca8958e24760729de79776"
        }
}

in upstream // overrides // additions

