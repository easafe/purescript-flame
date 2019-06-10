--the version of Flame.HTML.Event that works on the window/document using signals
module Flame.Signal.Global where

import Flame.Signal.Signal
import Flame.Types(Key)

foreign import onClick_ :: forall message. ToEventSignal_ message
foreign import onClick__ :: forall message. ToRawEventSignal_ message
foreign import onScroll_ :: forall message. ToEventSignal_ message
foreign import onScroll__ :: forall message. ToRawEventSignal_ message
foreign import onFocus_ :: forall message. ToEventSignal_ message
foreign import onFocus__ :: forall message. ToRawEventSignal_ message
foreign import onBlur_ :: forall message. ToEventSignal_ message
foreign import onBlur__ :: forall message. ToRawEventSignal_ message
foreign import onKeydown_ :: forall message. ToSpecialEventSignal_ message Key
foreign import onKeydown__ :: forall message. ToRawEventSignal_ message
foreign import onKeypress_ :: forall message. ToSpecialEventSignal_ message Key
foreign import onKeypress__ :: forall message. ToRawEventSignal_ message
foreign import onKeyup_ :: forall message. ToSpecialEventSignal_ message Key
foreign import onKeyup__ :: forall message. ToRawEventSignal_ message
foreign import onContextmenu_ :: forall message. ToEventSignal_ message
foreign import onContextmenu__ :: forall message. ToRawEventSignal_ message
foreign import onDblclick_ :: forall message. ToEventSignal_ message
foreign import onDblclick__ :: forall message. ToRawEventSignal_ message
foreign import onWheel_ :: forall message. ToEventSignal_ message
foreign import onWheel__ :: forall message. ToRawEventSignal_ message
foreign import onDrag_ :: forall message. ToEventSignal_ message
foreign import onDrag__ :: forall message. ToRawEventSignal_ message
foreign import onDragend_ :: forall message. ToEventSignal_ message
foreign import onDragend__ :: forall message. ToRawEventSignal_ message
foreign import onDragenter_ :: forall message. ToEventSignal_ message
foreign import onDragenter__ :: forall message. ToRawEventSignal_ message
foreign import onDragstart_ :: forall message. ToEventSignal_ message
foreign import onDragstart__ :: forall message. ToRawEventSignal_ message
foreign import onDragleave_ :: forall message. ToEventSignal_ message
foreign import onDragleave__ :: forall message. ToRawEventSignal_ message
foreign import onDragover_ :: forall message. ToEventSignal_ message
foreign import onDragover__ :: forall message. ToRawEventSignal_ message
foreign import onDrop_ :: forall message. ToEventSignal_ message
foreign import onDrop__ :: forall message. ToRawEventSignal_ message

onClick :: forall message. ToEventSignal message
onClick = createEventSignal onClick_

onClick' :: forall message. ToRawEventSignal message
onClick' = createRawEventSignal onClick__

onScroll :: forall message. ToEventSignal message
onScroll = createEventSignal onScroll_

onScroll' :: forall message. ToRawEventSignal message
onScroll' = createRawEventSignal onScroll__

onFocus :: forall message. ToEventSignal message
onFocus = createEventSignal onFocus_

onFocus' :: forall message. ToRawEventSignal message
onFocus' = createRawEventSignal onFocus__

onBlur :: forall message. ToEventSignal message
onBlur = createEventSignal onBlur_

onBlur' :: forall message. ToRawEventSignal message
onBlur' = createRawEventSignal onBlur__

onKeydown :: forall message. ToSpecialEventSignal message Key
onKeydown = createSpecialEventSignal onKeydown_

onKeydown' :: forall message. ToRawEventSignal message
onKeydown' = createRawEventSignal onKeydown__

onKeypress :: forall message. ToSpecialEventSignal message Key
onKeypress = createSpecialEventSignal onKeypress_

onKeypress' :: forall message. ToRawEventSignal message
onKeypress' = createRawEventSignal onKeypress__

onKeyup :: forall message. ToSpecialEventSignal message Key
onKeyup = createSpecialEventSignal onKeyup_

onKeyup' :: forall message. ToRawEventSignal message
onKeyup' = createRawEventSignal onKeyup__

onContextmenu :: forall message. ToEventSignal message
onContextmenu = createEventSignal onContextmenu_

onContextmenu' :: forall message. ToRawEventSignal message
onContextmenu' = createRawEventSignal onContextmenu__

onDblclick :: forall message. ToEventSignal message
onDblclick = createEventSignal onDblclick_

onDblclick' :: forall message. ToRawEventSignal message
onDblclick' = createRawEventSignal onDblclick__

onWheel :: forall message. ToEventSignal message
onWheel = createEventSignal onWheel_

onWheel' :: forall message. ToRawEventSignal message
onWheel' = createRawEventSignal onWheel__

onDrag :: forall message. ToEventSignal message
onDrag = createEventSignal onDrag_

onDrag' :: forall message. ToRawEventSignal message
onDrag' = createRawEventSignal onDrag__

onDragend :: forall message. ToEventSignal message
onDragend = createEventSignal onDragend_

onDragend' :: forall message. ToRawEventSignal message
onDragend' = createRawEventSignal onDragend__

onDragenter :: forall message. ToEventSignal message
onDragenter = createEventSignal onDragenter_

onDragenter' :: forall message. ToRawEventSignal message
onDragenter' = createRawEventSignal onDragenter__

onDragstart :: forall message. ToEventSignal message
onDragstart = createEventSignal onDragstart_

onDragstart' :: forall message. ToRawEventSignal message
onDragstart' = createRawEventSignal onDragstart__

onDragleave :: forall message. ToEventSignal message
onDragleave = createEventSignal onDragleave_

onDragleave' :: forall message. ToRawEventSignal message
onDragleave' = createRawEventSignal onDragleave__

onDragover :: forall message. ToEventSignal message
onDragover = createEventSignal onDragover_

onDragover' :: forall message. ToRawEventSignal message
onDragover' = createRawEventSignal onDragover__

onDrop :: forall message. ToEventSignal message
onDrop = createEventSignal onDrop_

onDrop' :: forall message. ToRawEventSignal message
onDrop' = createRawEventSignal onDrop__