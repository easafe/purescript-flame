module Test.Signal.EffectList (mount, TSELMessage(..)) where

-- | Counter example using a side effects free function
import Prelude

import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Element as HE
import Signal.Channel (Channel)

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data TSELMessage = TSELIncrement | TSELDecrement

-- | `update` is called to handle events
update :: Model -> TSELMessage -> Tuple Model (Array (Aff (Maybe TSELMessage)))
update model = case _ of
        TSELIncrement -> (model + 1) :> []
        TSELDecrement -> (model - 1) :> []

-- | `view` is called whenever the model is updated
view :: Model -> Html TSELMessage
view model = HE.main "main" [
        HE.span "text-output" $ show model
]

-- | Mount the application on the given selector
mount :: Effect (Channel (Array TSELMessage))
mount = FAE.mount "#mount-point" {
                init : 0 :> [],
                update,
                view
        }