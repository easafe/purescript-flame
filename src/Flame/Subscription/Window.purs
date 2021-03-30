-- | Defines events for the native `window` object
module Flame.Subscription.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload', onFocus) where

import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Source(..), Subscription)
import Web.Event.Internal.Types (Event)

onFocus :: forall message. message -> Subscription message
onFocus = FSIC.createSubscription Window "focus"

onFocus' :: forall message. (Event -> message) -> Subscription message
onFocus' = FSIC.createRawSubscription Window "focus"

onError :: forall message. message -> Subscription message
onError = FSIC.createSubscription Window "error"

onError' :: forall message. (Event -> message) -> Subscription message
onError' = FSIC.createRawSubscription Window "error"

onResize :: forall message. message -> Subscription message
onResize = FSIC.createSubscription Window "resize"

onResize' :: forall message. (Event -> message) -> Subscription message
onResize' = FSIC.createRawSubscription Window "resize"

onOffline :: forall message. message -> Subscription message
onOffline = FSIC.createSubscription Window "offline"

onOffline' :: forall message. (Event -> message) -> Subscription message
onOffline' = FSIC.createRawSubscription Window "offline"

onOnline :: forall message. message -> Subscription message
onOnline = FSIC.createSubscription Window "online"

onOnline' :: forall message. (Event -> message) -> Subscription message
onOnline' = FSIC.createRawSubscription Window "online"

onLoad :: forall message. message -> Subscription message
onLoad = FSIC.createSubscription Window "load"

onLoad' :: forall message. (Event -> message) -> Subscription message
onLoad' = FSIC.createRawSubscription Window "load"

onUnload :: forall message. message -> Subscription message
onUnload = FSIC.createSubscription Window "unload"

onUnload' :: forall message. (Event -> message) -> Subscription message
onUnload' = FSIC.createRawSubscription Window "unload"

