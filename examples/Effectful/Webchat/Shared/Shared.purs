module Examples.Effectful.Webchat.Shared where

import Prelude

wsPort :: Int
wsPort = 8888

wsAddress :: String
wsAddress = "ws://localhost" <> show wsPort