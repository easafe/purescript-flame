module Test.Subscription.Broadcast (mount, TSBMessage(..)) where

-- | Counter example using a side effects free function

import Prelude

import Data.Maybe (Maybe)
import Data.Maybe as DM
import Data.Tuple (Tuple)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html)
import Flame as F
import Flame.Application as FA
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Subscription as FS
import Web.DOM.ParentNode (QuerySelector(..))
import Web.Event.Event (EventType(..))

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data TSBMessage = TEELIncrement | TEELDecrement (Maybe Int)

-- | `update` is called to handle events
update ∷ Model → TSBMessage → Tuple Model (Array (Aff (Maybe TSBMessage)))
update model = case _ of
      TEELIncrement → (model + 1) /\ []
      TEELDecrement amount → (model - (DM.fromMaybe 1 amount)) /\ []

-- | `view` is called whenever the model is updated
view ∷ Model → Html TSBMessage
view model = HE.main [HA.id "main"]
      [ HE.span [HA.id "text-output"] [HE.text $ show model]
      ]

-- | Mount the application on the given selector
mount ∷ Effect Unit
mount = do
      F.mount_ (QuerySelector "#mount-point")
            { model: 0
            , subscribe: [ FS.onCustomEvent' (EventType "increment-event") TEELIncrement, FS.onCustomEvent (EventType "decrement-event") TEELDecrement ]
            , update
            , view
            }