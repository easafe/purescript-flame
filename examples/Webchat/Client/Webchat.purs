-- | Webchat example using effectful update and external events via channels
module Examples.Effectful.Webchat.Client.Main where

import Examples.Effectful.Webchat.Shared

import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Newtype (class Newtype)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Var (($=))
import Flame (AppId(..), Html, QuerySelector(..), (:>))
import Flame.Application.Effectful (Environment)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Subscription as FS
import Flame.Subscription.Window as FSW
import Partial.Unsafe (unsafePartial)
import Prelude (class Show, Unit, bind, discard, map, pure, ($), (<<<))
import Record as R
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

data WebchatApp = WebchatApp
instance wcShow :: Show WebchatApp where
      show _ = "WebchatApp"

-- | Mount the application on the given selector and bind WebSocket events
main :: Effect Unit
main = do
      let appId = AppId WebchatApp
      FAE.mount (QuerySelector "body") appId {
            init: init :> Nothing,
            subscribe: [FSW.onOnline $ Online true, FSW.onOffline $ Online false],
            update,
            view
      }

      Connection connection <- W.newWebSocket (URL wsAddress) []

      connection.onopen $= \event -> FS.send appId <<< SetSocket <<< Just $ Connection connection
      connection.onclose $= \event -> FS.send appId $ SetSocket Nothing
      connection.onmessage $= \event -> FS.send appId <<< Receive <<< W.runMessage $ W.runMessageEvent event