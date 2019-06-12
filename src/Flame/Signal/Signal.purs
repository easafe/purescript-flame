module Flame.Signal.Signal where

import Prelude

import Data.Foldable as DF
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Signal.Channel (Channel)
import Web.Event.Internal.Types (Event)

--need to map the messages

type ToEventSignal message = message -> Channel message -> Effect Unit

type ToSpecialEventSignal message parameter = forall f. f (parameter -> message) -> Channel (f message) -> Effect Unit

type ToRawEventSignal constructor = ToSpecialEventSignal constructor Event

type ToEventSignal_ message = EffectFn2 message (Channel message) Unit

type ToSpecialEventSignal_ message parameter = forall f. EffectFn2 (f (parameter -> message)) (Channel (f message)) Unit

type ToRawEventSignal_ constructor = ToSpecialEventSignal_ constructor Event

createEventSignal :: forall message. ToEventSignal_ message -> ToEventSignal message
createEventSignal ffi = EU.runEffectFn2 ffi

createRawEventSignal :: forall constructor. ToRawEventSignal_ constructor -> ToRawEventSignal constructor
createRawEventSignal ffi = EU.runEffectFn2 ffi

createSpecialEventSignal :: forall constructor parameter. ToSpecialEventSignal_ constructor parameter -> ToSpecialEventSignal constructor parameter
createSpecialEventSignal ffi = EU.runEffectFn2 ffi

send :: forall message f. Array (Channel (f message) -> Effect Unit) -> Channel (f message) -> Effect Unit
send events channel = DF.traverse_ apply events
        where apply handler = handler channel