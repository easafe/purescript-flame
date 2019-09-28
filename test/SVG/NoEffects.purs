module Test.SVG.NoEffects (mount) where

import Prelude

import Effect (Effect)
import Flame (QuerySelector(..), Html)
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
        HE.svg [HA.class' "svg-right i-ellipsis-vertical svg-32 svg-more", HA.viewBox "0 0 32 32"][
                HE.circle' [HA.cx $ show model, HA.cy "7", HA.r "2"],
                HE.circle' [HA.cx "16", HA.cy "16", HA.r "2"],
                HE.circle' [HA.cx "16", HA.cy "25", HA.r "2"]
        ],
        HE.button [HA.id "decrement-button", HA.onClick Decrement] "-",
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = FAN.mount_ (QuerySelector "#mount-point") {
                init,
                update,
                view
        }
