module Flame.Signal.Signal where

import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Signal (Signal)
import Signal as S
import Web.Event.Internal.Types (Event)

type ToEventSignal message = message -> Effect (Signal message)

type ToSpecialEventSignal constructor parameter = (parameter -> constructor) -> Effect (Signal constructor)

type ToRawEventSignal constructor = ToSpecialEventSignal constructor Event

type ToEventSignal_ message = EffectFn2 (message -> Signal message) message (Signal message)

type ToSpecialEventSignal_ constructor parameter = EffectFn2 (constructor -> Signal constructor) (parameter -> constructor) (Signal constructor)

type ToRawEventSignal_ constructor = ToSpecialEventSignal_ constructor Event

createEventSignal :: forall message. ToEventSignal_ message -> message -> Effect (Signal message)
createEventSignal ffi = EU.runEffectFn2 ffi S.constant

createRawEventSignal :: forall constructor. ToRawEventSignal_ constructor -> (Event -> constructor) -> Effect (Signal constructor)
createRawEventSignal ffi = EU.runEffectFn2 ffi S.constant

createSpecialEventSignal :: forall constructor parameter. ToSpecialEventSignal_ constructor parameter -> (parameter -> constructor) -> Effect (Signal constructor)
createSpecialEventSignal ffi = EU.runEffectFn2 ffi S.constant