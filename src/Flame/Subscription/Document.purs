-- | Defines events for the native `document` object
module Flame.Subscription.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel', onClickMaybe, onScrollMaybe, onFocusMaybe, onBlurMaybe, onKeydownMaybe, onKeydownMaybe', onKeypressMaybe, onKeypressMaybe', onKeyupMaybe, onKeyupMaybe', onContextmenuMaybe, onDblclickMaybe, onWheelMaybe, onDragMaybe, onDragendMaybe, onDragenterMaybe, onDragstartMaybe, onDragleaveMaybe, onDragoverMaybe, onDropMaybe) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Key, Source(..), Subscription)
import Prelude (pure, (<<<))
import Web.Event.Event (Event)

-- | click event fired for the document
onClick ∷ ∀ message. message → Subscription message
onClick = FSIC.createSubscription Document "click"

onClick' ∷ ∀ message. (Event → message) → Subscription message
onClick' message = FSIC.createRawSubscription Document "click" (pure <<< Just <<< message)

onScroll ∷ ∀ message. message → Subscription message
onScroll = FSIC.createSubscription Document "scroll"

onScroll' ∷ ∀ message. (Event → message) → Subscription message
onScroll' message = FSIC.createRawSubscription Document "scroll" (pure <<< Just <<< message)

onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Document "focus"

onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' message = FSIC.createRawSubscription Document "focus" (pure <<< Just <<< message)

onBlur ∷ ∀ message. message → Subscription message
onBlur = FSIC.createSubscription Document "blur"

onBlur' ∷ ∀ message. (Event → message) → Subscription message
onBlur' message = FSIC.createRawSubscription Document "blur" (pure <<< Just <<< message)

onKeydown ∷ ∀ message. (Key → message) → Subscription message
onKeydown message = FSIC.createRawSubscription Document "keydown" (pure <<< Just <<< message)

onKeydown' ∷ ∀ message. (Event → message) → Subscription message
onKeydown' message = FSIC.createRawSubscription Document "keydown" (pure <<< Just <<< message)

onKeypress ∷ ∀ message. (Key → message) → Subscription message
onKeypress message = FSIC.createRawSubscription Document "keypress" (pure <<< Just <<< message)

onKeypress' ∷ ∀ message. (Event → message) → Subscription message
onKeypress' message = FSIC.createRawSubscription Document "keypress" (pure <<< Just <<< message)

onKeyup ∷ ∀ message. (Key → message) → Subscription message
onKeyup message = FSIC.createRawSubscription Document "keyup" (pure <<< Just <<< message)

onKeyup' ∷ ∀ message. (Event → message) → Subscription message
onKeyup' message = FSIC.createRawSubscription Document "keyup" (pure <<< Just <<< message)

onContextmenu ∷ ∀ message. message → Subscription message
onContextmenu = FSIC.createSubscription Document "contextmenu"

onContextmenu' ∷ ∀ message. (Event → message) → Subscription message
onContextmenu' message = FSIC.createRawSubscription Document "contextmenu" (pure <<< Just <<< message)

onDblclick ∷ ∀ message. message → Subscription message
onDblclick = FSIC.createSubscription Document "dblclick"

onDblclick' ∷ ∀ message. (Event → message) → Subscription message
onDblclick' message = FSIC.createRawSubscription Document "dblclick" (pure <<< Just <<< message)

onWheel ∷ ∀ message. message → Subscription message
onWheel = FSIC.createSubscription Document "wheel"

onWheel' ∷ ∀ message. (Event → message) → Subscription message
onWheel' message = FSIC.createRawSubscription Document "wheel" (pure <<< Just <<< message)

onDrag ∷ ∀ message. message → Subscription message
onDrag = FSIC.createSubscription Document "drag"

onDrag' ∷ ∀ message. (Event → message) → Subscription message
onDrag' message = FSIC.createRawSubscription Document "drag" (pure <<< Just <<< message)

onDragend ∷ ∀ message. message → Subscription message
onDragend = FSIC.createSubscription Document "dragend"

onDragend' ∷ ∀ message. (Event → message) → Subscription message
onDragend' message = FSIC.createRawSubscription Document "dragend" (pure <<< Just <<< message)

onDragenter ∷ ∀ message. message → Subscription message
onDragenter = FSIC.createSubscription Document "dragenter"

onDragenter' ∷ ∀ message. (Event → message) → Subscription message
onDragenter' message = FSIC.createRawSubscription Document "dragenter" (pure <<< Just <<< message)

onDragstart ∷ ∀ message. message → Subscription message
onDragstart = FSIC.createSubscription Document "dragstart"

onDragstart' ∷ ∀ message. (Event → message) → Subscription message
onDragstart' message = FSIC.createRawSubscription Document "dragstart" (pure <<< Just <<< message)

onDragleave ∷ ∀ message. message → Subscription message
onDragleave = FSIC.createSubscription Document "dragleave"

onDragleave' ∷ ∀ message. (Event → message) → Subscription message
onDragleave' message = FSIC.createRawSubscription Document "dragleave" (pure <<< Just <<< message)

onDragover ∷ ∀ message. message → Subscription message
onDragover = FSIC.createSubscription Document "dragover"

onDragover' ∷ ∀ message. (Event → message) → Subscription message
onDragover' message = FSIC.createRawSubscription Document "dragover" (pure <<< Just <<< message)

onDrop ∷ ∀ message. message → Subscription message
onDrop = FSIC.createSubscription Document "drop"

onDrop' ∷ ∀ message. (Event → message) → Subscription message
onDrop' message = FSIC.createRawSubscription Document "drop" (pure <<< Just <<< message)

-- | Maybe versions for advanced handlers that can return Nothing
onClickMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onClickMaybe = FSIC.createRawSubscription Document "click"

onScrollMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onScrollMaybe = FSIC.createRawSubscription Document "scroll"

onFocusMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onFocusMaybe = FSIC.createRawSubscription Document "focus"

onBlurMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onBlurMaybe = FSIC.createRawSubscription Document "blur"

onKeydownMaybe ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeydownMaybe = FSIC.createRawSubscription Document "keydown"

onKeydownMaybe' ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onKeydownMaybe' = FSIC.createRawSubscription Document "keydown"

onKeypressMaybe ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeypressMaybe = FSIC.createRawSubscription Document "keypress"

onKeypressMaybe' ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onKeypressMaybe' = FSIC.createRawSubscription Document "keypress"

onKeyupMaybe ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeyupMaybe = FSIC.createRawSubscription Document "keyup"

onKeyupMaybe' ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onKeyupMaybe' = FSIC.createRawSubscription Document "keyup"

onContextmenuMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onContextmenuMaybe = FSIC.createRawSubscription Document "contextmenu"

onDblclickMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDblclickMaybe = FSIC.createRawSubscription Document "dblclick"

onWheelMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onWheelMaybe = FSIC.createRawSubscription Document "wheel"

onDragMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragMaybe = FSIC.createRawSubscription Document "drag"

onDragendMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragendMaybe = FSIC.createRawSubscription Document "dragend"

onDragenterMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragenterMaybe = FSIC.createRawSubscription Document "dragenter"

onDragstartMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragstartMaybe = FSIC.createRawSubscription Document "dragstart"

onDragleaveMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragleaveMaybe = FSIC.createRawSubscription Document "dragleave"

onDragoverMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragoverMaybe = FSIC.createRawSubscription Document "dragover"

onDropMaybe ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDropMaybe = FSIC.createRawSubscription Document "drop"