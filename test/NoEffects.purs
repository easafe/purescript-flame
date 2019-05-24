module Test.NoEffects (mount) where

import Prelude

import Effect (Effect)
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA

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
        HE.span "text-output" $ show model,
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = FAN.mount "#mount-point" {
        init,
        update,
        view,
        signals: []
}
