-- | Defines events for the native `document` object
module Flame.Subscription.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel') where

import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Key, Source(..), Subscription)
import Web.Event.Event (Event)

-- | click event fired for the document
onClick ∷ ∀ message. message → Subscription message
onClick = FSIC.createSubscription Document "click"

onClick' ∷ ∀ message. (Event → message) → Subscription message
onClick' = FSIC.createRawSubscription Document "click"

onScroll ∷ ∀ message. message → Subscription message
onScroll = FSIC.createSubscription Document "scroll"

onScroll' ∷ ∀ message. (Event → message) → Subscription message
onScroll' = FSIC.createRawSubscription Document "scroll"

onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Document "focus"

onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' = FSIC.createRawSubscription Document "focus"

onBlur ∷ ∀ message. message → Subscription message
onBlur = FSIC.createSubscription Document "blur"

onBlur' ∷ ∀ message. (Event → message) → Subscription message
onBlur' = FSIC.createRawSubscription Document "blur"

onKeydown ∷ ∀ message. (Key → message) → Subscription message
onKeydown = FSIC.createRawSubscription Document "keydown"

onKeydown' ∷ ∀ message. (Event → message) → Subscription message
onKeydown' = FSIC.createRawSubscription Document "keydown"

onKeypress ∷ ∀ message. (Key → message) → Subscription message
onKeypress = FSIC.createRawSubscription Document "keypress"

onKeypress' ∷ ∀ message. (Event → message) → Subscription message
onKeypress' = FSIC.createRawSubscription Document "keypress"

onKeyup ∷ ∀ message. (Key → message) → Subscription message
onKeyup = FSIC.createRawSubscription Document "keyup"

onKeyup' ∷ ∀ message. (Event → message) → Subscription message
onKeyup' = FSIC.createRawSubscription Document "keyup"

onContextmenu ∷ ∀ message. message → Subscription message
onContextmenu = FSIC.createSubscription Document "contextmenu"

onContextmenu' ∷ ∀ message. (Event → message) → Subscription message
onContextmenu' = FSIC.createRawSubscription Document "contextmenu"

onDblclick ∷ ∀ message. message → Subscription message
onDblclick = FSIC.createSubscription Document "dblclick"

onDblclick' ∷ ∀ message. (Event → message) → Subscription message
onDblclick' = FSIC.createRawSubscription Document "dblclick"

onWheel ∷ ∀ message. message → Subscription message
onWheel = FSIC.createSubscription Document "wheel"

onWheel' ∷ ∀ message. (Event → message) → Subscription message
onWheel' = FSIC.createRawSubscription Document "wheel"

onDrag ∷ ∀ message. message → Subscription message
onDrag = FSIC.createSubscription Document "drag"

onDrag' ∷ ∀ message. (Event → message) → Subscription message
onDrag' = FSIC.createRawSubscription Document "drag"

onDragend ∷ ∀ message. message → Subscription message
onDragend = FSIC.createSubscription Document "dragend"

onDragend' ∷ ∀ message. (Event → message) → Subscription message
onDragend' = FSIC.createRawSubscription Document "dragend"

onDragenter ∷ ∀ message. message → Subscription message
onDragenter = FSIC.createSubscription Document "dragenter"

onDragenter' ∷ ∀ message. (Event → message) → Subscription message
onDragenter' = FSIC.createRawSubscription Document "dragenter"

onDragstart ∷ ∀ message. message → Subscription message
onDragstart = FSIC.createSubscription Document "dragstart"

onDragstart' ∷ ∀ message. (Event → message) → Subscription message
onDragstart' = FSIC.createRawSubscription Document "dragstart"

onDragleave ∷ ∀ message. message → Subscription message
onDragleave = FSIC.createSubscription Document "dragleave"

onDragleave' ∷ ∀ message. (Event → message) → Subscription message
onDragleave' = FSIC.createRawSubscription Document "dragleave"

onDragover ∷ ∀ message. message → Subscription message
onDragover = FSIC.createSubscription Document "dragover"

onDragover' ∷ ∀ message. (Event → message) → Subscription message
onDragover' = FSIC.createRawSubscription Document "dragover"

onDrop ∷ ∀ message. message → Subscription message
onDrop = FSIC.createSubscription Document "drop"

onDrop' ∷ ∀ message. (Event → message) → Subscription message
onDrop' = FSIC.createRawSubscription Document "drop"