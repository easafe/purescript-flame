module Examples.Dice.Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (Html)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Data.Tuple(Tuple)

type Model = Maybe Int

init :: Model
init = Nothing

data Message = Roll | Update Int

update :: Model -> Message -> Tuple Model (Array (Aff Message))
update model = case _ of
        Roll -> model :> [
                Update <$> liftEffect (ER.randomInt 1 6)
        ]
        Update int -> Just int :> []

view :: Model -> Html Message
view model = HE.main "main" [
        HE.text (show model),
        HE.button [HA.onClick Roll] "Roll"
]

main :: Effect Unit
main = FAE.mount "main" {
        init: init,
        update: update,
        view,
        inputs:[]
}