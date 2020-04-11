module Test.TextContent.NoEffects (mount) where

import Prelude

import Effect (Effect)
import Flame (QuerySelector(..), Html)
import Flame.Application.NoEffects as FAN
import Flame.External as FE
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
view 0 = HE.text "Nothing to show"
view model = HE.main_ [
        HE.button [HA.id "decrement-button", HA.onClick Decrement] "-",
        HE.span "text-output" $ show model,
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = do
        channel <- FAN.mount (QuerySelector "#mount-point") {
                init,
                update,
                view
        }
        FE.send [FE.onClick [Increment], FE.onOffline [Decrement]] channel
