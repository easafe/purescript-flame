-- | Defines events for the native `window` object
module Flame.Subscription.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload', onFocus, onFocus', onPopstate, onPopstate', onErrorMaybe, onLoadMaybe, onOfflineMaybe, onOnlineMaybe, onResizeMaybe, onUnloadMaybe, onFocusMaybe, onPopstateMaybe) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Source(..), Subscription)
import Prelude (pure, (<<<))
import Web.Event.Internal.Types (Event)

onPopstate ∷ ∀ message. message → Subscription message
onPopstate = FSIC.createSubscription Window "popstate"

onPopstate' ∷ ∀ message. (Event → message) → Subscription message
onPopstate' message = FSIC.createRawSubscription Window "popstate" (pure <<< Just <<< message)

onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Window "focus"

onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' message = FSIC.createRawSubscription Window "focus" (pure <<< Just <<< message)

onError ∷ ∀ message. message → Subscription message
onError = FSIC.createSubscription Window "error"

onError' ∷ ∀ message. (Event → message) → Subscription message
onError' message = FSIC.createRawSubscription Window "error" (pure <<< Just <<< message)

onResize ∷ ∀ message. message → Subscription message
onResize = FSIC.createSubscription Window "resize"

onResize' ∷ ∀ message. (Event → message) → Subscription message
onResize' message = FSIC.createRawSubscription Window "resize" (pure <<< Just <<< message)

onOffline ∷ ∀ message. message → Subscription message
onOffline = FSIC.createSubscription Window "offline"

onOffline' ∷ ∀ message. (Event → message) → Subscription message
onOffline' message = FSIC.createRawSubscription Window "offline" (pure <<< Just <<< message)

onOnline ∷ ∀ message. message → Subscription message
onOnline = FSIC.createSubscription Window "online"

onOnline' ∷ ∀ message. (Event → message) → Subscription message
onOnline' message = FSIC.createRawSubscription Window "online" (pure <<< Just <<< message)

onLoad ∷ ∀ message. message → Subscription message
onLoad = FSIC.createSubscription Window "load"

onLoad' ∷ ∀ message. (Event → message) → Subscription message
onLoad' message = FSIC.createRawSubscription Window "load" (pure <<< Just <<< message)

onUnload ∷ ∀ message. message → Subscription message
onUnload = FSIC.createSubscription Window "unload"

onUnload' ∷ ∀ message. (Event → message) → Subscription message
onUnload' message = FSIC.createRawSubscription Window "unload" (pure <<< Just <<< message)

-- | Maybe versions for advanced handlers that can return Nothing
onErrorMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onErrorMaybe = FSIC.createRawSubscription Window "error"

onLoadMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onLoadMaybe = FSIC.createRawSubscription Window "load"

onOfflineMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onOfflineMaybe = FSIC.createRawSubscription Window "offline"

onOnlineMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onOnlineMaybe = FSIC.createRawSubscription Window "online"

onResizeMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onResizeMaybe = FSIC.createRawSubscription Window "resize"

onUnloadMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onUnloadMaybe = FSIC.createRawSubscription Window "unload"

onFocusMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onFocusMaybe = FSIC.createRawSubscription Window "focus"

onPopstateMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onPopstateMaybe = FSIC.createRawSubscription Window "popstate"

