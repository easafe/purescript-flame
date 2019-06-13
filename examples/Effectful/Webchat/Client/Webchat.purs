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
import Flame (Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Signal as FS
import Signal.Channel as SC
import WebSocket (Connection(..), URL(..))
import WebSocket as W

type Model = {
        history :: Array String,
        message :: String,
        isOnline :: Boolean,
        connection :: Maybe Connection
}

data Message = SetSocket (Maybe Connection) | SetMessage String | Send | Receive String | Online Boolean

init :: Model
init = {
        history: [],
        message: "",
        isOnline: true,
        connection: Nothing
}

update :: World Model Message -> Model -> Message -> Aff Model
update re model (SetSocket connection) = re.update (model { connection = connection }) <<< Online $ DM.isJust connection
update _ model (Receive text) = pure $ model { history = DA.snoc model.history text }
update _ model (Online isOnline) = pure $ model { isOnline = isOnline }
update _ model (SetMessage text) = pure $ model { message = text }
update re model Send = do
        case model.connection of
                Just (Connection socket) -> do
                        liftEffect $ socket.send $ W.Message model.message
                        re.update model (Receive model.message)
                _ -> pure model

view :: Model -> Html Message
view model = HE.main "main" [
        HE.div_ $ map (HE.span [HA.class' "history-entry"]) model.history,
        HE.input [
                HA.onInput SetMessage,
                HA.type' "text",
                HA.placeholder $ if model.isOnline then "Type a message" else "You are offline"
        ],
        HE.button [HA.onClick Send] "Send"
]

main :: Effect Unit
main = do
        channel <- F.mount "main" {
                init: init :> Nothing,
                update,
                view
        }

        FS.send [FS.onOnline (Just $ Online true), FS.onOffline (Just $ Online false)] channel

        Connection connection <- W.newWebSocket (URL wsAddress) []

        connection.onopen $= \event -> SC.send channel <<< Just <<< SetSocket <<< Just $ Connection connection
        connection.onclose $= \event -> SC.send channel <<< Just $ SetSocket Nothing
        connection.onmessage $= \event -> SC.send channel <<< Just <<< Receive <<< W.runMessage $ W.runMessageEvent event