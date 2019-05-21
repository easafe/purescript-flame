-- | Testing playground, do not depend on this file
module Test.Test where

import Prelude

import Effect (Effect)
import Effect.Class.Console (log)
import Effect.Unsafe (unsafePerformEffect)
import Flame (Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

-- | The model represents the state of the app
type Model = String

-- | This datatype is used to signal events to `update`
data Message = Selection String

-- | Initial state of the app
init :: Model
init = ""

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        Selection s -> s

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.input [HA.type' "test", HA.onSelect Selection ],
        HE.text $ "You have selected " <> model
]

-- | Mount the application on the given selector
main :: Effect Unit
main = FAN.mount "main" {
        init,
        update,
        view,
        inputs: []
}
