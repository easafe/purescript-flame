-- | Defines helpers for events from outside the view (e.g., custom/window or document events)
-- | For view events, see `Flame.Html.Attribute`
module Flame.Subscription (
      send,
      onCustomEvent,
      onCustomEvent'
) where

import Data.Tuple.Nested as DTN
import Effect (Effect)
import Flame.Application.Internal.Dom as FAID
import Flame.Serialization (class UnserializeState)
import Flame.Serialization as FS
import Flame.Types (AppId(..), Source(..), Subscription)
import Foreign as F
import Prelude (class Show, Unit, const, show, (<<<))
import Web.Event.Event (EventType(..))

-- | Raises an arbitrary message on the given application
send :: forall id message. Show id => AppId id message -> message -> Effect Unit
send (AppId id) message = FAID.dispatchCustomEvent (show id) message

-- | Subscribe to a `CustomEvent`
-- |
-- | `arg` must be serializable since it might come from external JavaScript
onCustomEvent :: forall arg message. UnserializeState arg => EventType -> (arg -> message) -> Subscription message
onCustomEvent (EventType eventName) message = DTN.tuple3 Custom eventName (message <<< FS.unsafeUnserialize <<< F.unsafeFromForeign)

-- | Subscribe to a `CustomEvent` that has no data associated
onCustomEvent' :: forall message. EventType -> message -> Subscription message
onCustomEvent' (EventType eventName) message = DTN.tuple3 Custom eventName (const message)
