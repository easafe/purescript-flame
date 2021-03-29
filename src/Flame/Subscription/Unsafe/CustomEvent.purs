module Flame.Subscription.Unsafe.CustomEvent where

import Effect (Effect)
import Flame.Application.Internal.Dom as FAID
import Flame.Serialization (class SerializeState)
import Flame.Serialization as FS
import Prelude (Unit, (<<<))
import Web.Event.Event (EventType(..))

-- | Broadcast a `CustomEvent` to all applications
-- |
-- | This is considered unsafe as there is no guarantee that the payload matches listeners' expectations
broadcast :: forall arg. SerializeState arg => EventType -> arg -> Effect Unit
broadcast (EventType eventName) = FAID.dispatchCustomEvent eventName <<< FS.serialize