-- | Defines events for the native `document` object
module Flame.Subscription.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel') where

import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Key, Source(..), Subscription)
import Web.Event.Event (Event)

-- | click event fired for the document
onClick :: forall message. message -> Subscription message
onClick = FSIC.createSubscription Document "click"

onClick' :: forall message. (Event -> message) -> Subscription message
onClick' = FSIC.createRawSubscription Document "click"

onScroll :: forall message. message -> Subscription message
onScroll = FSIC.createSubscription Document "scroll"

onScroll' :: forall message. (Event -> message) -> Subscription message
onScroll' = FSIC.createRawSubscription Document "scroll"

onFocus :: forall message. message -> Subscription message
onFocus = FSIC.createSubscription Document "focus"

onFocus' :: forall message. (Event -> message) -> Subscription message
onFocus' = FSIC.createRawSubscription Document "focus"

onBlur :: forall message. message -> Subscription message
onBlur = FSIC.createSubscription Document "blur"

onBlur' :: forall message. (Event -> message) -> Subscription message
onBlur' = FSIC.createRawSubscription Document "blur"

onKeydown :: forall message. (Key -> message) -> Subscription message
onKeydown = FSIC.createRawSubscription Document "keydown"

onKeydown' :: forall message. (Event -> message) -> Subscription message
onKeydown' = FSIC.createRawSubscription Document "keydown"

onKeypress :: forall message. (Key -> message) -> Subscription message
onKeypress = FSIC.createRawSubscription Document "keypress"

onKeypress' :: forall message. (Event -> message) -> Subscription message
onKeypress' = FSIC.createRawSubscription Document "keypress"

onKeyup :: forall message. (Key -> message) -> Subscription message
onKeyup = FSIC.createRawSubscription Document "keyup"

onKeyup' :: forall message. (Event -> message) -> Subscription message
onKeyup' = FSIC.createRawSubscription Document "keyup"

onContextmenu :: forall message. message -> Subscription message
onContextmenu = FSIC.createSubscription Document "contextmenu"

onContextmenu' :: forall message. (Event -> message) -> Subscription message
onContextmenu' = FSIC.createRawSubscription Document "contextmenu"

onDblclick :: forall message. message -> Subscription message
onDblclick = FSIC.createSubscription Document "dblclick"

onDblclick' :: forall message. (Event -> message) -> Subscription message
onDblclick' = FSIC.createRawSubscription Document "dblclick"

onWheel :: forall message. message -> Subscription message
onWheel = FSIC.createSubscription Document "wheel"

onWheel' :: forall message. (Event -> message) -> Subscription message
onWheel' = FSIC.createRawSubscription Document "wheel"

onDrag :: forall message. message -> Subscription message
onDrag = FSIC.createSubscription Document "drag"

onDrag' :: forall message. (Event -> message) -> Subscription message
onDrag' = FSIC.createRawSubscription Document "drag"

onDragend :: forall message. message -> Subscription message
onDragend = FSIC.createSubscription Document "dragend"

onDragend' :: forall message. (Event -> message) -> Subscription message
onDragend' = FSIC.createRawSubscription Document "dragend"

onDragenter :: forall message. message -> Subscription message
onDragenter = FSIC.createSubscription Document "dragenter"

onDragenter' :: forall message. (Event -> message) -> Subscription message
onDragenter' = FSIC.createRawSubscription Document "dragenter"

onDragstart :: forall message. message -> Subscription message
onDragstart = FSIC.createSubscription Document "dragstart"

onDragstart' :: forall message. (Event -> message) -> Subscription message
onDragstart' = FSIC.createRawSubscription Document "dragstart"

onDragleave :: forall message. message -> Subscription message
onDragleave = FSIC.createSubscription Document "dragleave"

onDragleave' :: forall message. (Event -> message) -> Subscription message
onDragleave' = FSIC.createRawSubscription Document "dragleave"

onDragover :: forall message. message -> Subscription message
onDragover = FSIC.createSubscription Document "dragover"

onDragover' :: forall message. (Event -> message) -> Subscription message
onDragover' = FSIC.createRawSubscription Document "dragover"

onDrop :: forall message. message -> Subscription message
onDrop = FSIC.createSubscription Document "drop"

onDrop' :: forall message. (Event -> message) -> Subscription message
onDrop' = FSIC.createRawSubscription Document "drop"