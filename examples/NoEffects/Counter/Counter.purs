-- | Counter example using side effects free updating
module Examples.NoEffects.Counter.Main where

import Prelude

import Effect (Effect)
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement

-- | Initial state of the app
init :: Model
init = 0

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        Increment -> model + 1
        Decrement -> model - 1

-- | `view` updates the app markup whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.onClick Decrement] "-",
        HE.text $ show model,
        HE.button [HA.onClick Increment] "+"
]

-- | Mount the application on the given selector
main :: Effect Unit
main = FAN.mount_ "main" {
        init,
        update,
        view
}