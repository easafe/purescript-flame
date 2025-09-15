let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.15-20250904/packages.dhall
        sha256:65df863430bac51dc71eb6c31d60f837bccf3837ddae929e1bc53830d299ab37

let overrides = {=}

let additions = {=}

in  upstream // overrides // additions
