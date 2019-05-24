module Examples.NoEffects.Counters.Main where

import Prelude

import Data.Array ((!!))
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Effect (Effect)
import Examples.NoEffects.Counter.Main as ECM
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = Array ECM.Model

data Message = Add | Remove Int | CounterMessage Int ECM.Message

init :: Model
init = []

update :: Model -> Message -> Model
update model = case _ of
        Add -> DA.snoc model ECM.init
        Remove index -> DM.fromMaybe model $ DA.deleteAt index model
        CounterMessage index message ->
                case model !! index of
                        Nothing -> model
                        Just model' -> DM.fromMaybe model $ DA.updateAt index (ECM.update model' message) model

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.onClick Add] "Add",
        HE.div_ $ DA.mapWithIndex viewCounter model
]
        where   viewCounter index model' = HE.div [HA.style { display: "flex" }] [
                        CounterMessage index <$> ECM.view model',
                        HE.button [HA.onClick $ Remove index] "Remove"
                ]

main :: Effect Unit
main =  FAN.mount "main" {
        init,
        update,
        view,
        signals: []
}
