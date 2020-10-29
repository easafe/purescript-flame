let upstream =
    https://github.com/purescript/package-sets/releases/download/psc-0.13.8-20200822/packages.dhall sha256:b4f151f1af4c5cb6bf5437489f4231fbdd92792deaf32971e6bcb0047b3dd1f8

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
              "signal",
              "foreign-object",
              "argonaut-generic"
            ]
            , repo =
                "https://github.com/easafe/purescript-flame.git"
            , version =
                "e04514f4a03d492896f01b93c2d6e403e39d354e"
        }
}

in upstream // overrides // additions