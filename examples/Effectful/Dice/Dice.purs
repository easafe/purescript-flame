module Examples.Effectful.Dice.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE

type Model = Maybe Int

init :: Model
init = Nothing

data Message = Roll

update :: AffUpdate Model Message
update { model } = map (const <<< Just) $ liftEffect $ ER.randomInt 1 6

view :: Model -> Html Message
view model = HE.main "main" [
        HE.text (show model),
        HE.button [HA.onClick Roll] "Roll"
]

main :: Effect Unit
main = FAE.mount_ (QuerySelector "main") {
        init: init :> Nothing,
        update,
        view
}
