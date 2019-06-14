module Examples.Effectful.Webchat.Server.Main where

import Examples.Effectful.Webchat.Server.WS
import Examples.Effectful.Webchat.Shared
import Prelude

import Effect (Effect)

main :: Effect Unit
main = pure unit