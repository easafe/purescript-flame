module Test.External.NoEffects (mount) where

-- | Counter example using a side effects free function
import Prelude

import Effect (Effect)
import Flame (QuerySelector(..), Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Element as HE
import Web.Event.Internal.Types (Event)
import Flame.External as FE

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment String | Decrement Event

-- | `update` is called to handle events
update :: Model -> Message -> Model
update model = case _ of
        Increment _ -> model + 1
        Decrement _ -> model - 1

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" [
        HE.span "text-output" $ show model
]

-- | Mount the application on the given selector
mount :: Effect Unit
mount = do
        channel <- FAN.mount (QuerySelector "#mount-point") {
                init : 0,
                update,
                view
        }
        FE.send [FE.onClick' [Decrement], FE.onKeydown [Increment]] channel