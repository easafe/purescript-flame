module Flame.Signal.Signal where

import Prelude

import Data.Foldable as DF
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn3)
import Effect.Uncurried as EU
import Signal.Channel (Channel)
import Web.Event.Internal.Types (Event)

type ToEventSignal message = message -> Channel message -> Effect Unit

type ToSpecialEventSignal message parameter = forall f. Applicative f => f (parameter -> message) -> Channel (f message) -> Effect Unit

type ToRawEventSignal constructor = ToSpecialEventSignal constructor Event

type ToEventSignal_ message = EffectFn2 message (Channel message) Unit

type ToSpecialEventSignal_ message parameter = forall f. Applicative f => EffectFn3 (parameter -> f (parameter -> message) -> f message) (f (parameter -> message)) (Channel (f message)) Unit

type ToRawEventSignal_ constructor = ToSpecialEventSignal_ constructor Event

createEventSignal :: forall message. ToEventSignal_ message -> ToEventSignal message
createEventSignal ffi = EU.runEffectFn2 ffi

createRawEventSignal :: forall constructor. ToRawEventSignal_ constructor -> ToRawEventSignal constructor
createRawEventSignal ffi = EU.runEffectFn3 ffi applyHandler

createSpecialEventSignal :: forall constructor parameter. ToSpecialEventSignal_ constructor parameter -> ToSpecialEventSignal constructor parameter
createSpecialEventSignal ffi = EU.runEffectFn3 ffi applyHandler

applyHandler :: forall f message parameter. Applicative f => parameter -> f (parameter -> message) -> f message
applyHandler parameter handler = handler <*> pure parameter

send :: forall message. Array (Channel message -> Effect Unit) -> Channel message -> Effect Unit
send events channel = DF.traverse_ apply events
        where apply handler = handler channel