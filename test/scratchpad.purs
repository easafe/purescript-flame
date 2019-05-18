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
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement | D Boolean | I Boolean

-- | Initial state of the app
init :: Model
init = 0

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        I b-> if b then model + 1 else model - 1
        Increment -> const (model + 1) $ unsafePerformEffect (log "increment")
        D b -> const (if b then model + 1 else model - 1) $ unsafePerformEffect (log (show b))
        Decrement -> const (model - 1) $ unsafePerformEffect (log "decrement")

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        --HE.button [HA.onClick Decrement] "-",
        -- HE.input [HA.type' "checkbox",HA.onFocus Decrement, HA.onCheck D],
        -- HE.input [HA.type' "radio", HA.onFocus Increment, HA.name "name1", HA.onCheck I],
        -- HE.input [HA.type' "radio", HA.name "name1", HA.onFocus Increment, HA.onCheck I],
        HE.input [HA.type' "test", HA.onFocus Increment, HA.onBlur Decrement ],
        HE.text $ show model
        --HE.button [HA.onClick Increment] "+"
]

-- | Mount the application on the given selector
main :: Effect Unit
main = FAN.mount "main" {
        init,
        update,
        view,
        inputs: []
}
