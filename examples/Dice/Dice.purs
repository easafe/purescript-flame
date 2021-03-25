module Examples.EffectList.Dice.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), Html, (:>))
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Data.Tuple(Tuple)

type Model = Maybe Int

init :: Model
init = Nothing

data Message = Roll | Update Int

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Roll -> model :> [
            Just <<< Update <$> liftEffect (ER.randomInt 1 6)
      ]
      Update int -> Just int :> []

view :: Model -> Html Message
view model = HE.main "main" [
      HE.text (show model),
      HE.button [HA.onClick Roll] "Roll"
]

main :: Effect Unit
main = F.mount_ (QuerySelector "body") {
      init: init :> [],
      update,
      view
}
