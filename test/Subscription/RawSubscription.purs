module Test.Subscription.RawSubscription (mount, TSRSMessage(..)) where

-- | Test to verify that no updates occur when createRawSubscription returns Nothing

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Subscription.Internal.Create (createRawSubscription)
import Flame.Types (Source(..))
import Web.DOM.ParentNode (QuerySelector(..))

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data TSRSMessage = TSRSIncrement | TSRSDecrement

-- | `update` is called to handle events
update ∷ Model → TSRSMessage → Tuple Model (Array (Aff (Maybe TSRSMessage)))
update model = case _ of
      TSRSIncrement → (model + 1) /\ []
      TSRSDecrement → (model - 1) /\ []

-- | `view` is called whenever the model is updated
view ∷ Model → Html TSRSMessage
view model = HE.main [ HA.id "main" ]
      [ HE.span [ HA.id "text-output" ] [ HE.text $ show model ]
      ]

-- | Mount the application on the given selector
mount ∷ Effect Unit
mount = do
      F.mount_ (QuerySelector "#mount-point")
            { model: 0
            , subscribe:
                    [ createRawSubscription Custom "nothing-event" (\_ → pure Nothing)
                    , createRawSubscription Custom "just-event" (\_ → pure (Just TSRSIncrement))
                    ]
            , update
            , view
            }
