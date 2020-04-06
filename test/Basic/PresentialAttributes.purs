module Test.Basic.PresentialAttributes (mount) where

import Prelude

import Effect (Effect)
import Flame (QuerySelector(..), Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = Int

data Message = Increment | Decrement

init :: Model
init = 0

update :: Model -> Message -> Model
update model = case _ of
        Increment -> model + 1
        Decrement -> model - 1

view :: Model -> Html Message
view model = HE.main_ [
        HE.button [HA.id "decrement-button", HA.onClick Decrement] "-",
        HE.input [HA.id "checkbox", HA.type' "checked", HA.checked $ model == 0, HA.disabled $ model == 1],
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = FAN.mount_ (QuerySelector "#mount-point") {
                init,
                update,
                view
        }
