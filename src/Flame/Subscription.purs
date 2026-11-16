-- | Defines helpers for events from outside the view (e.g., custom/window or document events)
-- | For view events, see `Flame.Html.Attribute`
module Flame.Subscription
      ( send
      , onCustomEvent
      , onCustomEvent'
      , onCustomEvent_
      ) where

import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Flame.Application.Internal.Dom as FAID
import Flame.Subscription.Internal.Listener as FSIL
import Flame.Serialization (class Serializable)
import Flame.Serialization as FS
import Flame.Types (AppId(..), Source(..), Subscription)
import Foreign as F
import Prelude (class Show, Unit, bind, const, pure, show, (<<<))
import Web.Event.Event (EventType(..))

-- | Raises an arbitrary message on the given application
-- |
-- | Messages sent before the application is mounted are queued until it is
send ∷ ∀ id message. Show id ⇒ AppId id message → message → Effect Unit
send (AppId id) message = do
      let applicationId = show id
      initialized ← FSIL.isApplicationInitialized applicationId
      if initialized then
            FAID.dispatchCustomEvent applicationId message
      else
            FSIL.queueMessage applicationId message

-- | Subscribe to a `CustomEvent` that has no data associated
onCustomEvent ∷ ∀ message. EventType → message → Subscription message
onCustomEvent (EventType eventName) message = Custom /\ eventName /\ pure <<< Just <<< const message

-- | Subscribe to a `CustomEvent`, building the message from its payload
-- |
-- | `arg` must be serializable since it might come from external JavaScript
onCustomEvent' ∷ ∀ arg message. Serializable arg ⇒ EventType → (arg → message) → Subscription message
onCustomEvent' (EventType eventName) message = Custom /\ eventName /\ pure <<< Just <<< message <<< FS.unsafeUnserialize <<< F.unsafeFromForeign

-- | Subscribe to a `CustomEvent` with an effectful handler that may return `Nothing`
-- |
-- | `arg` must be serializable since it might come from external JavaScript
onCustomEvent_ ∷ ∀ arg message. Serializable arg ⇒ EventType → (arg → Effect (Maybe message)) → Subscription message
onCustomEvent_ (EventType eventName) message = Custom /\ eventName /\ message <<< FS.unsafeUnserialize <<< F.unsafeFromForeign