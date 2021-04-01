module Flame.Subscription.Unsafe.CustomEvent(
    broadcast,
    broadcast'
) where

import Effect (Effect)
import Flame.Application.Internal.Dom as FAID
import Flame.Serialization (class SerializeState)
import Flame.Serialization as FS
import Prelude (Unit, unit, (<<<))
import Web.Event.Event (EventType(..))

-- | Broadcast a `CustomEvent` to all applications
-- |
-- | This is considered unsafe as there is no guarantee that the payload matches listeners' expectations
broadcast :: forall arg. SerializeState arg => EventType -> arg -> Effect Unit
broadcast (EventType eventName) = FAID.dispatchCustomEvent eventName <<< FS.serialize

-- | Broadcast a `CustomEvent` that has no data associated to all applications
-- |
-- | This is considered unsafe as there is no guarantee that the payload matches listeners' expectations
broadcast' :: EventType -> Effect Unit
broadcast' (EventType eventName) = FAID.dispatchCustomEvent eventName unit