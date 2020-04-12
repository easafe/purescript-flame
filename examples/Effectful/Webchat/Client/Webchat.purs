-- | Webchat example using effectful update and external events via channels
module Examples.Effectful.Webchat.Client.Main where

import Examples.Effectful.Webchat.Shared
import Prelude

import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Newtype (class Newtype)
import Data.Newtype as DN
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Var (($=))
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (Environment)
import Flame.Application.Effectful as FAE
import Flame.External as FE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Partial.Unsafe (unsafePartial)
import Record as R
import Signal.Channel as SC
import WebSocket (Connection(..), URL(..))
import WebSocket as W

-- | The model represents the state of the app
newtype Model = Model {
        history :: Array String,
        message :: String,
        isOnline :: Boolean,
        connection :: Maybe Connection
}

derive instance modelNewtype :: Newtype Model _

-- | This datatype is used to signal events to `update`
data Message = SetSocket (Maybe Connection) | SetMessage String | Send | Receive String | Online Boolean

-- | Initial state of the app
init :: Model
init = Model {
        history: ["Welcome to the chat!"],
        message: "",
        isOnline: true,
        connection: Nothing
}

-- | `update` is called to handle events
update :: Environment Model Message -> Aff (Model -> Model)
update { model: Model model, message, display } =
        case message of
                SetSocket connection -> FAE.diff $ R.merge (setIsOnline $ DM.isJust connection) { connection }
                Receive text -> pure $ \(Model m@{ history }) -> Model $ m { history = DA.snoc history text }
                Online isOnline -> FAE.diff $ setIsOnline isOnline
                SetMessage text -> FAE.diff { message: text }
                Send -> do
                        display $ FAE.diff' { message: "" }
                        let Connection socket = unsafePartial $ DM.fromJust model.connection
                        liftEffect $ socket.send $ W.Message model.message
                        FAE.noChanges

        where setIsOnline isIt = { isOnline: isIt }

-- | `view` updates the app markup whenever the model is updated
view :: Model -> Html Message
view (Model model) = HE.main "main" [
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
        channel <- FAE.mount (QuerySelector "main") {
                init: init :> Nothing,
                update,
                view
        }

        FE.send [FE.onOnline (Just $ Online true), FE.onOffline (Just $ Online false)] channel

        Connection connection <- W.newWebSocket (URL wsAddress) []

        connection.onopen $= \event -> SC.send channel <<< Just <<< SetSocket <<< Just $ Connection connection
        connection.onclose $= \event -> SC.send channel <<< Just $ SetSocket Nothing
        connection.onmessage $= \event -> SC.send channel <<< Just <<< Receive <<< W.runMessage $ W.runMessageEvent event