module Flame.Subscription.Internal.Create
      ( createSubscription
      , createRawSubscription
      ) where

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Flame.Html.Event (EventName)
import Flame.Types (Source, Subscription)
import Foreign as F
import Prelude (const, pure, (<<<))

createSubscription ∷ ∀ message. Source → EventName → message → Subscription message
createSubscription source eventName message = source /\ eventName /\ pure <<< Just <<< const message

createRawSubscription ∷ ∀ arg message. Source → EventName → (arg → Effect (Maybe message)) → Subscription message
createRawSubscription source eventName message =  source /\ eventName /\ message <<< F.unsafeFromForeign
