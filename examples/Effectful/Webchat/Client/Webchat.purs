-- | Webchat example using effectful update and external events via channels
module Examples.Effectful.Webchat.Client.Main where

import Examples.Effectful.Webchat.Shared
import Prelude

import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Var (($=))
import Flame (QuerySelector(..), Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.External as FE
import Partial.Unsafe (unsafePartial)
import Signal.Channel as SC
import WebSocket (Connection(..), URL(..))
import WebSocket as W

-- | The model represents the state of the app
type Model = {
        history :: Array String,
        message :: String,
        isOnline :: Boolean,
        connection :: Maybe Connection
}

-- | This datatype is used to signal events to `update`
data Message = SetSocket (Maybe Connection) | SetMessage String | Send | Receive String | Online Boolean

-- | Initial state of the app
init :: Model
init = {
        history: ["Welcome to the chat!"],
        message: "",
        isOnline: true,
        connection: Nothing
}

-- | `update` is called to handle events
update :: World Model Message -> Model -> Message -> Aff Model
update re model (SetSocket connection) = re.update (model { connection = connection }) <<< Online $ DM.isJust connection
update _ model (Receive text) = pure $ model { history = DA.snoc model.history text }
update _ model (Online isOnline) = pure $ model { isOnline = isOnline }
update _ model (SetMessage text) = pure $ model { message = text }
update re model Send = do
        let Connection socket = unsafePartial (DM.fromJust model.connection)
        liftEffect $ socket.send $ W.Message model.message
        pure $ model { message = "" }

-- | `view` updates the app markup whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.div "history" $ map HE.div_ model.history,
        HE.div "send" [
                HE.input [
                        HA.onInput SetMessage,
                        HA.type' "text",
                        HA.value model.message,
                        HA.placeholder $ if model.isOnline then "Type a message" else "You are offline"
                ],
                HE.button [HA.onClick Send] "Send"
        ]
]

-- | Mount the application on the given selector and bind WebSocket events to the app channel
main :: Effect Unit
main = do
        channel <- F.mount (QuerySelector "main") {
                init: init :> Nothing,
                update,
                view
        }

        FE.send [FE.onOnline (Just $ Online true), FE.onOffline (Just $ Online false)] channel

        Connection connection <- W.newWebSocket (URL wsAddress) []

        connection.onopen $= \event -> SC.send channel <<< Just <<< SetSocket <<< Just $ Connection connection
        connection.onclose $= \event -> SC.send channel <<< Just $ SetSocket Nothing
        connection.onmessage $= \event -> SC.send channel <<< Just <<< Receive <<< W.runMessage $ W.runMessageEvent event