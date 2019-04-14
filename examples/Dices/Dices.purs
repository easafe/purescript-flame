module Examples.Dices.Main where

import Prelude

import Data.Array as DA
import Data.Maybe as DM
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Examples.Dice.Main as EDM
import Flame (Html)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = Array EDM.Model

data Message = Add | Remove Int | DiceMessage Int EDM.Message

init :: Model
init = []

update :: Model -> Message -> Tuple Model (Array (Aff Message))
update model = case _ of
        Add -> DA.snoc model EDM.init :> []
        Remove index -> DA.deleteAt index model # DM.fromMaybe model
        DiceMessage index msg -> DA.modifyAt index (\model' -> EDM.update model' msg) model # DM.fromMaybe model

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.onClick Add] "Add",
        HE.div_ $ DA.mapWithIndex viewCounter model
]
        where   viewCounter index model' = HE.div [HA.style { display: "flex" }] [
                        DiceMessage index <$> EDM.view model',
                        HE.button [HA.onClick $ Remove index] "Remove"
                ]

main :: Effect Unit
main = FAE.mount "main" {
        init: init,
        update: update,
        view,
        inputs:[]
}
