module Flame.External.Source (createEventSource, createRawEventSource, createSpecialEventSource, send) where

import Prelude

import Data.Foldable as DF
import Effect (Effect)
import Effect.Uncurried as EU
import Flame.External.Types (ToEventSource, ToEventSource_, ToRawEventSource, ToRawEventSource_, ToSpecialEventSource, ToSpecialEventSource_)
import Signal.Channel (Channel)

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