-- | Defines events for the native `window` object
module Flame.Subscription.Window
      ( onPopstate
      , onPopstate'
      , onFocus
      , onFocus'
      , onError
      , onError'
      , onResize
      , onResize'
      , onOffline
      , onOffline'
      , onOnline
      , onOnline'
      , onLoad
      , onLoad'
      , onUnload
      , onUnload'
      , onError_
      , onLoad_
      , onOffline_
      , onOnline_
      , onResize_
      , onUnload_
      , onFocus_
      , onPopstate_
      ) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Source(..), Subscription)
import Prelude (pure, (<<<))
import Web.Event.Internal.Types (Event)

-- | Raises the given message when `window` fires the `popstate` event
onPopstate ∷ ∀ message. message → Subscription message
onPopstate = FSIC.createSubscription Window "popstate"

-- | Raises a message built from the `popstate` event of `window`
onPopstate' ∷ ∀ message. (Event → message) → Subscription message
onPopstate' message = FSIC.createRawSubscription Window "popstate" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `focus` event
onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Window "focus"

-- | Raises a message built from the `focus` event of `window`
onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' message = FSIC.createRawSubscription Window "focus" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `error` event
onError ∷ ∀ message. message → Subscription message
onError = FSIC.createSubscription Window "error"

-- | Raises a message built from the `error` event of `window`
onError' ∷ ∀ message. (Event → message) → Subscription message
onError' message = FSIC.createRawSubscription Window "error" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `resize` event
onResize ∷ ∀ message. message → Subscription message
onResize = FSIC.createSubscription Window "resize"

-- | Raises a message built from the `resize` event of `window`
onResize' ∷ ∀ message. (Event → message) → Subscription message
onResize' message = FSIC.createRawSubscription Window "resize" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `offline` event
onOffline ∷ ∀ message. message → Subscription message
onOffline = FSIC.createSubscription Window "offline"

-- | Raises a message built from the `offline` event of `window`
onOffline' ∷ ∀ message. (Event → message) → Subscription message
onOffline' message = FSIC.createRawSubscription Window "offline" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `online` event
onOnline ∷ ∀ message. message → Subscription message
onOnline = FSIC.createSubscription Window "online"

-- | Raises a message built from the `online` event of `window`
onOnline' ∷ ∀ message. (Event → message) → Subscription message
onOnline' message = FSIC.createRawSubscription Window "online" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `load` event
onLoad ∷ ∀ message. message → Subscription message
onLoad = FSIC.createSubscription Window "load"

-- | Raises a message built from the `load` event of `window`
onLoad' ∷ ∀ message. (Event → message) → Subscription message
onLoad' message = FSIC.createRawSubscription Window "load" (pure <<< Just <<< message)

-- | Raises the given message when `window` fires the `unload` event
onUnload ∷ ∀ message. message → Subscription message
onUnload = FSIC.createSubscription Window "unload"

-- | Raises a message built from the `unload` event of `window`
onUnload' ∷ ∀ message. (Event → message) → Subscription message
onUnload' message = FSIC.createRawSubscription Window "unload" (pure <<< Just <<< message)

-- | Maybe versions for advanced handlers that can return Nothing
onError_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onError_ = FSIC.createRawSubscription Window "error"

-- | Handles the `load` event of `window` with an effectful handler that may return `Nothing`
onLoad_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onLoad_ = FSIC.createRawSubscription Window "load"

-- | Handles the `offline` event of `window` with an effectful handler that may return `Nothing`
onOffline_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onOffline_ = FSIC.createRawSubscription Window "offline"

-- | Handles the `online` event of `window` with an effectful handler that may return `Nothing`
onOnline_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onOnline_ = FSIC.createRawSubscription Window "online"

-- | Handles the `resize` event of `window` with an effectful handler that may return `Nothing`
onResize_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onResize_ = FSIC.createRawSubscription Window "resize"

-- | Handles the `unload` event of `window` with an effectful handler that may return `Nothing`
onUnload_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onUnload_ = FSIC.createRawSubscription Window "unload"

-- | Handles the `focus` event of `window` with an effectful handler that may return `Nothing`
onFocus_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onFocus_ = FSIC.createRawSubscription Window "focus"

-- | Handles the `popstate` event of `window` with an effectful handler that may return `Nothing`
onPopstate_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onPopstate_ = FSIC.createRawSubscription Window "popstate"

