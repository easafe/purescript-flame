module Flame.Subscription.Internal.Create
      ( createSubscription
      , createRawSubscription
      ) where

import Data.Tuple.Nested as DTN
import Flame.Html.Event (EventName)
import Flame.Types (Source, Subscription)
import Foreign as F
import Prelude (const, (<<<))

createSubscription ∷ ∀ message. Source → EventName → message → Subscription message
createSubscription source eventName message = DTN.tuple3 source eventName (const message)

createRawSubscription ∷ ∀ arg message. Source → EventName → (arg → message) → Subscription message
createRawSubscription source eventName message = DTN.tuple3 source eventName (message <<< F.unsafeFromForeign)
