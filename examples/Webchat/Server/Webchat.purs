-- | Quick and dirty WebSocket server
module Examples.Effectful.Webchat.Server.Main where

import Examples.Effectful.Webchat.Shared
import Prelude

import Data.Array as DA
import Data.Foldable as DF
import Effect (Effect)
import Effect.Console as EC
import Effect.Ref as ER
import Examples.Effectful.Webchat.Server.WS (Port(..))
import Examples.Effectful.Webchat.Server.WS as EEWSW

main :: Effect Unit
main = do
      database <- ER.new {
            connections: [],
            messages: []
      }
      wss <- EEWSW.createWebSocketServerWithPort (Port wsPort) {} $ const (EC.log $ "Listening on port " <> show wsPort)
      EEWSW.onConnection wss (onConnection database)
      EEWSW.onServerError wss onError

      where handleMessage database _ message = do
                  ER.modify_ (\db -> db { messages = DA.snoc db.messages $ show message }) database
                  connections <- _.connections <$> ER.read database
                  DF.traverse_  (_ `EEWSW.sendMessage` message) connections

            onError = EC.log <<< show

            onConnection database ws _ = do
                  ER.modify_ (\db -> db { connections = DA.snoc db.connections ws }) database
                  EEWSW.onMessage ws $ handleMessage database ws
                  EEWSW.onError ws onError