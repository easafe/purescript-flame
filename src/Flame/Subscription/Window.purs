-- | Defines events for the native `window` object
module Flame.Subscription.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload', onFocus, onFocus', onPopstate, onPopstate') where

import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Source(..), Subscription)
import Web.Event.Internal.Types (Event)

onPopstate ∷ ∀ message. message → Subscription message
onPopstate = FSIC.createSubscription Window "popstate"

onPopstate' ∷ ∀ message. (Event → message) → Subscription message
onPopstate' = FSIC.createRawSubscription Window "popstate"

onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Window "focus"

onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' = FSIC.createRawSubscription Window "focus"

onError ∷ ∀ message. message → Subscription message
onError = FSIC.createSubscription Window "error"

onError' ∷ ∀ message. (Event → message) → Subscription message
onError' = FSIC.createRawSubscription Window "error"

onResize ∷ ∀ message. message → Subscription message
onResize = FSIC.createSubscription Window "resize"

onResize' ∷ ∀ message. (Event → message) → Subscription message
onResize' = FSIC.createRawSubscription Window "resize"

onOffline ∷ ∀ message. message → Subscription message
onOffline = FSIC.createSubscription Window "offline"

onOffline' ∷ ∀ message. (Event → message) → Subscription message
onOffline' = FSIC.createRawSubscription Window "offline"

onOnline ∷ ∀ message. message → Subscription message
onOnline = FSIC.createSubscription Window "online"

onOnline' ∷ ∀ message. (Event → message) → Subscription message
onOnline' = FSIC.createRawSubscription Window "online"

onLoad ∷ ∀ message. message → Subscription message
onLoad = FSIC.createSubscription Window "load"

onLoad' ∷ ∀ message. (Event → message) → Subscription message
onLoad' = FSIC.createRawSubscription Window "load"

onUnload ∷ ∀ message. message → Subscription message
onUnload = FSIC.createSubscription Window "unload"

onUnload' ∷ ∀ message. (Event → message) → Subscription message
onUnload' = FSIC.createRawSubscription Window "unload"

