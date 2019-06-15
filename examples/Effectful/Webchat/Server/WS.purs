-- | WS node library bindings adapted from https://github.com/FruitieX/purescript-ws
module Examples.Effectful.Webchat.Server.WS where
import Prelude

import Data.Newtype (class Newtype)
import Record as R
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Exception (Error)
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn3)
import Effect.Uncurried as EU
import Node.HTTP (Request, Server)
import Type.Row (class Lacks, class Cons, class Union)

foreign import data WebSocketServer :: Type
foreign import data WebSocketConnection :: Type
foreign import createWebSocketServer_ :: forall e options . EffectFn2 options (EffectFn1 Unit Unit) WebSocketServer
foreign import onConnection_ :: forall e . EffectFn2 WebSocketServer (EffectFn2 WebSocketConnection Request Unit)Unit
foreign import onServerError_ :: forall e . EffectFn2 WebSocketServer (EffectFn1 Error Unit) Unit
foreign import onMessage_ :: forall e . EffectFn2 WebSocketConnection (EffectFn1 WebSocketMessage Unit) Unit
foreign import onClose_ :: forall e . EffectFn2 WebSocketConnection (EffectFn2 CloseCode CloseReason Unit) Unit
foreign import onError_ :: forall e . EffectFn2 WebSocketConnection (EffectFn1 Error Unit) Unit
foreign import sendMessage_ :: forall e . EffectFn2 WebSocketConnection WebSocketMessage Unit
foreign import close_ :: forall e . EffectFn3 WebSocketConnection CloseCode CloseReason Unit

newtype WebSocketMessage = WebSocketMessage String
derive newtype instance showWSM :: Show WebSocketMessage
derive instance newtypeWSM :: Newtype WebSocketMessage _

type WebSocketServerOptions = (host :: String, backlog :: Int )

-- | The port to listen on if calling createWebSocketServerWithPort
newtype Port = Port Int
newtype CloseCode = CloseCode Int
newtype CloseReason = CloseReason String

-- | Creates a WebSocket.Server and internally a HTTP server
-- | which binds to a given port
-- |
-- | The supplied callback is called when the created HTTP server
-- | starts listening.
createWebSocketServerWithPort :: forall e options options' trash . Union options options' WebSocketServerOptions => Lacks "port" options => Cons "port" Port options trash => Port -> { | options } -> (Unit -> Effect Unit) -> Effect WebSocketServer
createWebSocketServerWithPort (Port port) options callback = EU.runEffectFn2 createWebSocketServer_ options' callback'
        where   options' = R.insert (SProxy :: SProxy "port") port options
                callback' = EU.mkEffectFn1 callback

-- | Attaches a connection event handler to a WebSocketServer
onConnection :: forall e . WebSocketServer -> (WebSocketConnection -> Request -> Effect Unit) -> Effect Unit
onConnection server callback = EU.runEffectFn2 onConnection_ server (EU.mkEffectFn2 callback)

-- | Attaches an error event handler to a WebSocketServer
onServerError :: forall e . WebSocketServer -> (Error -> Effect Unit) -> Effect Unit
onServerError server callback = EU.runEffectFn2 onServerError_ server (EU.mkEffectFn1 callback)

-- | Attaches a message event handler to a WebSocketConnection
onMessage :: forall e . WebSocketConnection -> (WebSocketMessage -> Effect Unit) -> Effect Unit
onMessage ws callback = EU.runEffectFn2 onMessage_ ws (EU.mkEffectFn1 callback)

-- | Attaches a close event handler to a WebSocketConnection
onClose :: forall e . WebSocketConnection -> (CloseCode -> CloseReason -> Effect Unit) -> Effect Unit
onClose ws callback = EU.runEffectFn2 onClose_ ws (EU.mkEffectFn2 callback)

-- | Attaches an error event handler to a WebSocketConnection
onError :: forall e . WebSocketConnection -> (Error -> Effect Unit) -> Effect Unit
onError ws callback = EU.runEffectFn2 onError_ ws (EU.mkEffectFn1 callback)

-- | Send a message over a WebSocketConnection
sendMessage :: forall e . WebSocketConnection -> WebSocketMessage -> Effect Unit
sendMessage ws message = EU.runEffectFn2 sendMessage_ ws message

-- | Initiate a closing handshake
close :: forall e . WebSocketConnection -> Effect Unit
close ws = EU.runEffectFn3 close_ ws (CloseCode 1000) (CloseReason "Closed by server")

-- | Initiate a closing handshake with given code and reason
close' :: forall e . WebSocketConnection -> CloseCode -> CloseReason -> Effect Unit
close' ws code reason = EU.runEffectFn3 close_ ws code reason
