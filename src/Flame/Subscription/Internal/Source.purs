module Flame.Subscription.Internal.Create
      ( createSubscription
      , createRawSubscription
      ) where

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Flame.Types (EventName, Source, Subscription)
import Foreign as F
import Prelude (const, pure, (<<<))

-- | Subscription that raises a fixed message whenever the event fires
createSubscription ∷ ∀ message. Source → EventName → message → Subscription message
createSubscription source eventName message = source /\ eventName /\ pure <<< Just <<< const message

-- | Subscription whose handler receives the raw event payload (unsafely coerced to `arg`) and may not raise a message
createRawSubscription ∷ ∀ arg message. Source → EventName → (arg → Effect (Maybe message)) → Subscription message
createRawSubscription source eventName message =  source /\ eventName /\ message <<< F.unsafeFromForeign
