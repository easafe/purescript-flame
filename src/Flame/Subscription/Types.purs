module Flame.Subscription.Types where

import Prelude

import Effect (Effect)
import Signal.Channel (Channel)
import Effect.Uncurried (EffectFn2, EffectFn3)
import Web.Event.Internal.Types (Event)

type ToEventSource message = message -> Channel message -> Effect Unit

type ToSpecialEventSource message parameter = forall f. Applicative f => f (parameter -> message) -> Channel (f message) -> Effect Unit

type ToRawEventSource constructor = ToSpecialEventSource constructor Event

type ToEventSource_ message = EffectFn2 message (Channel message) Unit

type ToSpecialEventSource_ message parameter = forall f. Applicative f => EffectFn3 (parameter -> f (parameter -> message) -> f message) (f (parameter -> message)) (Channel (f message)) Unit

type ToRawEventSource_ constructor = ToSpecialEventSource_ constructor Event