module Test.Effectful (mount) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = {
        increments :: Int,
        decrements :: Int,
        luckyNumber :: Int
}

data Message = Increment | Decrement | Bogus

init :: Model
init = { increments: 0, decrements: 0, luckyNumber: 0 }

update :: World Model Message -> Model -> Message -> Aff Model
update re model = case _ of
        Increment -> do
                re.view (model { luckyNumber = model.increments - 2 })
                pure $ model { increments = model.increments + 1}
        Decrement -> re.update (model { luckyNumber = model.increments + 2, decrements = model.decrements - 1 }) Bogus
        Bogus -> pure model

view :: Model -> Html Message
view model = HE.main_ [
        HE.span "text-output-increment" $ show model.increments,
        HE.span "text-output-decrement" $ show model.decrements,
        HE.span "text-output-lucky-number" $ show model.luckyNumber,
        HE.br,
        --we add extra events for each button to test if the correct message is used
        HE.button [HA.id "decrement-button", HA.onClick Decrement, HA.onFocus Increment, HA.onDrag Increment] "-",
        HE.button [HA.id "increment-button", HA.onClick Increment, HA.onFocus Decrement, HA.onDrag Bogus] "+"
]

mount :: Effect Unit
mount = F.mount "#mount-point" {
        init: init :> Just Decrement,
        update,
        view,
        signals: []
}
