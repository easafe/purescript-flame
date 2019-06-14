--the version of Flame.HTML.Event that works on the window/document using signals
module Flame.Signal.Document where

-- USE THE MKFN FUNCTIONS FROM https://pursuit.purescript.org/packages/purescript-functions/4.0.0/docs/Data.Function.Uncurried

import Flame.Signal.Signal
import Flame.Types (Key)

foreign import onClick_ :: forall message. ToEventSource_ message
foreign import onClick__ :: forall message. ToRawEventSource_ message
foreign import onScroll_ :: forall message. ToEventSource_ message
foreign import onScroll__ :: forall message. ToRawEventSource_ message
foreign import onFocus_ :: forall message. ToEventSource_ message
foreign import onFocus__ :: forall message. ToRawEventSource_ message
foreign import onBlur_ :: forall message. ToEventSource_ message
foreign import onBlur__ :: forall message. ToRawEventSource_ message
foreign import onKeydown_ :: forall message. ToSpecialEventSource_ message Key
foreign import onKeydown__ :: forall message. ToRawEventSource_ message
foreign import onKeypress_ :: forall message. ToSpecialEventSource_ message Key
foreign import onKeypress__ :: forall message. ToRawEventSource_ message
foreign import onKeyup_ :: forall message. ToSpecialEventSource_ message Key
foreign import onKeyup__ :: forall message. ToRawEventSource_ message
foreign import onContextmenu_ :: forall message. ToEventSource_ message
foreign import onContextmenu__ :: forall message. ToRawEventSource_ message
foreign import onDblclick_ :: forall message. ToEventSource_ message
foreign import onDblclick__ :: forall message. ToRawEventSource_ message
foreign import onWheel_ :: forall message. ToEventSource_ message
foreign import onWheel__ :: forall message. ToRawEventSource_ message
foreign import onDrag_ :: forall message. ToEventSource_ message
foreign import onDrag__ :: forall message. ToRawEventSource_ message
foreign import onDragend_ :: forall message. ToEventSource_ message
foreign import onDragend__ :: forall message. ToRawEventSource_ message
foreign import onDragenter_ :: forall message. ToEventSource_ message
foreign import onDragenter__ :: forall message. ToRawEventSource_ message
foreign import onDragstart_ :: forall message. ToEventSource_ message
foreign import onDragstart__ :: forall message. ToRawEventSource_ message
foreign import onDragleave_ :: forall message. ToEventSource_ message
foreign import onDragleave__ :: forall message. ToRawEventSource_ message
foreign import onDragover_ :: forall message. ToEventSource_ message
foreign import onDragover__ :: forall message. ToRawEventSource_ message
foreign import onDrop_ :: forall message. ToEventSource_ message
foreign import onDrop__ :: forall message. ToRawEventSource_ message

onClick :: forall message. ToEventSource message
onClick = createEventSource onClick_

onClick' :: forall message. ToRawEventSource message
onClick' = createRawEventSource onClick__

onScroll :: forall message. ToEventSource message
onScroll = createEventSource onScroll_

onScroll' :: forall message. ToRawEventSource message
onScroll' = createRawEventSource onScroll__

onFocus :: forall message. ToEventSource message
onFocus = createEventSource onFocus_

onFocus' :: forall message. ToRawEventSource message
onFocus' = createRawEventSource onFocus__

onBlur :: forall message. ToEventSource message
onBlur = createEventSource onBlur_

onBlur' :: forall message. ToRawEventSource message
onBlur' = createRawEventSource onBlur__

onKeydown :: forall message. ToSpecialEventSource message Key
onKeydown = createSpecialEventSource onKeydown_

onKeydown' :: forall message. ToRawEventSource message
onKeydown' = createRawEventSource onKeydown__

onKeypress :: forall message. ToSpecialEventSource message Key
onKeypress = createSpecialEventSource onKeypress_

onKeypress' :: forall message. ToRawEventSource message
onKeypress' = createRawEventSource onKeypress__

onKeyup :: forall message. ToSpecialEventSource message Key
onKeyup = createSpecialEventSource onKeyup_

onKeyup' :: forall message. ToRawEventSource message
onKeyup' = createRawEventSource onKeyup__

onContextmenu :: forall message. ToEventSource message
onContextmenu = createEventSource onContextmenu_

onContextmenu' :: forall message. ToRawEventSource message
onContextmenu' = createRawEventSource onContextmenu__

onDblclick :: forall message. ToEventSource message
onDblclick = createEventSource onDblclick_

onDblclick' :: forall message. ToRawEventSource message
onDblclick' = createRawEventSource onDblclick__

onWheel :: forall message. ToEventSource message
onWheel = createEventSource onWheel_

onWheel' :: forall message. ToRawEventSource message
onWheel' = createRawEventSource onWheel__

onDrag :: forall message. ToEventSource message
onDrag = createEventSource onDrag_

onDrag' :: forall message. ToRawEventSource message
onDrag' = createRawEventSource onDrag__

onDragend :: forall message. ToEventSource message
onDragend = createEventSource onDragend_

onDragend' :: forall message. ToRawEventSource message
onDragend' = createRawEventSource onDragend__

onDragenter :: forall message. ToEventSource message
onDragenter = createEventSource onDragenter_

onDragenter' :: forall message. ToRawEventSource message
onDragenter' = createRawEventSource onDragenter__

onDragstart :: forall message. ToEventSource message
onDragstart = createEventSource onDragstart_

onDragstart' :: forall message. ToRawEventSource message
onDragstart' = createRawEventSource onDragstart__

onDragleave :: forall message. ToEventSource message
onDragleave = createEventSource onDragleave_

onDragleave' :: forall message. ToRawEventSource message
onDragleave' = createRawEventSource onDragleave__

onDragover :: forall message. ToEventSource message
onDragover = createEventSource onDragover_

onDragover' :: forall message. ToRawEventSource message
onDragover' = createRawEventSource onDragover__

onDrop :: forall message. ToEventSource message
onDrop = createEventSource onDrop_

onDrop' :: forall message. ToRawEventSource message
onDrop' = createRawEventSource onDrop__