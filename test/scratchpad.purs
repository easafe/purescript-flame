-- | Testing playground, do not depend on this file
module Test.ScratchPad where


import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful as FAE
import Flame.External as FE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Types (NodeData(..))
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (Event, stopPropagation)

type Model = Int

data Message = Increment Event | Decrement Event

init :: Model
init = 0

update { model, message } = case message of
        Increment event -> do
                liftEffect $ stopPropagation event
                pure (_ + 1)
        Decrement event -> do
                liftEffect $ stopPropagation event
                pure (_ - 1)

view :: Model -> Html Message
view 0 = HE.text "alert('oi')"
view model = HE.template "oi" [
        HE.button [HA.id "decrement-button", HA.onClick' Decrement] "-",
        HE.span "text-output" $ show model,
        HE.span_ "alert('oi')",
        HE.button [HA.id "increment-button", HA.onClick' Increment] "+"
]

main :: Effect Unit
main = do
        channel <- FAE.mount (QuerySelector "#mount-point") {
                init : init :> Nothing,
                update,
                view
        }
        FE.send [FE.onClick' (Just Increment), FE.onKeydown' (Just Decrement)] channel
