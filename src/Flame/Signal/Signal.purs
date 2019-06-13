module Flame.Signal.Signal where

import Prelude

import Data.Foldable as DF
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn3)
import Effect.Uncurried as EU
import Signal.Channel (Channel)
import Web.Event.Internal.Types (Event)

type ToEventSource message = message -> Channel message -> Effect Unit

type ToSpecialEventSource message parameter = forall f. Applicative f => f (parameter -> message) -> Channel (f message) -> Effect Unit

type ToRawEventSource constructor = ToSpecialEventSource constructor Event

type ToEventSource_ message = EffectFn2 message (Channel message) Unit

type ToSpecialEventSource_ message parameter = forall f. Applicative f => EffectFn3 (parameter -> f (parameter -> message) -> f message) (f (parameter -> message)) (Channel (f message)) Unit

type ToRawEventSource_ constructor = ToSpecialEventSource_ constructor Event

createEventSource :: forall message. ToEventSource_ message -> ToEventSource message
createEventSource ffi = EU.runEffectFn2 ffi

createRawEventSource :: forall constructor. ToRawEventSource_ constructor -> ToRawEventSource constructor
createRawEventSource ffi = EU.runEffectFn3 ffi applyHandler

createSpecialEventSource :: forall constructor parameter. ToSpecialEventSource_ constructor parameter -> ToSpecialEventSource constructor parameter
createSpecialEventSource ffi = EU.runEffectFn3 ffi applyHandler

applyHandler :: forall f message parameter. Applicative f => parameter -> f (parameter -> message) -> f message
applyHandler parameter handler = handler <*> pure parameter

send :: forall message. Array (Channel message -> Effect Unit) -> Channel message -> Effect Unit
send events channel = DF.traverse_ apply events
        where apply handler = handler channel