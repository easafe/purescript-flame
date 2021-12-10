module Test.Subscription.EffectList (mount, TEELMessage(..)) where

-- | Counter example using a side effects free function

import Prelude

import Data.Maybe (Maybe)
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.EffectList as FAE
import Flame.Html.Element as HE
import Flame.Types (AppId(..))

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data TEELMessage = TEELIncrement | TEELDecrement

-- | `update` is called to handle events
update ∷ Model → TEELMessage → Tuple Model (Array (Aff (Maybe TEELMessage)))
update model = case _ of
      TEELIncrement → (model + 1) :> []
      TEELDecrement → (model - 1) :> []

-- | `view` is called whenever the model is updated
view ∷ Model → Html TEELMessage
view model = HE.main "main"
      [ HE.span "text-output" $ show model
      ]

-- | Mount the application on the given selector
mount ∷ Effect (AppId String TEELMessage)
mount = do
      let id = AppId "teel"
      FAE.mount (QuerySelector "#mount-point") id
            { init: 0 :> []
            , subscribe: []
            , update
            , view
            }
      pure id