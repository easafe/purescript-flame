module Examples.Effectful.Webchat.Client.Main where

import Prelude

import Affjax as A
import Affjax.ResponseFormat as AR
import Data.Array as DA
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Traversable as DF
import Effect (Effect)
import Effect.Aff (Aff, message)
import Flame (Html, World, (:>))
import Flame as F
import Effect.Var (($=))
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Signal as FS
import WebSocket (Connection(..), Message(..), URL(..))
import WebSocket as W
import Examples.Effectful.Webchat.Shared

type Model = {
        history :: Array String,
        message :: String,
        isOnline :: Boolean
}

data Message = SetMessage String | Send | Receive String | Online Boolean

init :: Model
init = {
        history: [],
        message: "",
        isOnline: true
}

update :: World Model Message -> Model -> Message -> Aff Model
update _ model (Receive text) = pure $ model { history = DA.snoc model.history text }
update _ model (Online isOnline) = pure $ model { isOnline = isOnline }
update _ model (SetMessage text) = pure $ model { message = text }
update re model Send = do
        sendMessage model.message
        re.update model (Receive model.message)

        where sendMessage text = ?jpol

view :: Model -> Html Message
view model = HE.main "main" [
        HE.div_ $ DF.traverse (HE.span [HA.class' "history-entry"]) model.history,
        HE.input [
                HA.onInput SetMessage,
                HA.type' "text",
                HA.placeholder $ if model.isOnline then "Type a message" else "You are offline"
        ],
        HE.button [HA.onClick Send] "Send"
]

main :: Effect Unit
main = do
        Connection socket <- W.newWebSocket (URL wsAddress) []
        socket.onopen $= \event -> do

        socket.onmessage $= \event -> do
        socket.onclose $= \event -> do

        F.mount "main" {
                init: init :> Nothing,
                update,
                view,
                signals : [
                        FS.onOnline $ Online true,
                        FS.onOffline $ Online false,

                ]
        }
