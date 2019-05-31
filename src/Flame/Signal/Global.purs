--the version of Flame.HTML.Event that works on the window/document using signals
module Flame.Signal.Global where

import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Signal (Signal)
import Signal as S
import Web.Event.Internal.Types (Event)

type ToEventSignal message = message -> Effect (Signal message)

type ToRawEventSignal constructor = (Event-> constructor Event) -> Effect (Signal (constructor Event))

type ToEventSignal_ message = EffectFn2 (message -> Signal message) message (Signal message)

type ToRawEventSignal_ constructor = EffectFn2 ((constructor Event) -> Signal (constructor Event)) (Event -> constructor Event) (Signal (constructor Event))

createEventSignal :: forall message. ToEventSignal_ message -> message -> Effect (Signal message)
createEventSignal ffi = EU.runEffectFn2 ffi S.constant

createRawEventSignal :: forall constructor. ToRawEventSignal_ constructor -> (Event -> constructor Event) -> Effect (Signal (constructor Event))
createRawEventSignal ffi = EU.runEffectFn2 ffi S.constant

foreign import onClick_ :: forall message. ToEventSignal_ message
foreign import onClick__ :: forall message. ToRawEventSignal_ message

onClick :: forall message. ToEventSignal message
onClick = createEventSignal onClick_

onClick' :: forall message. ToRawEventSignal message
onClick' = createRawEventSignal onClick__

onKeydown :: forall message. ToSpecialEventSignal message (Tuple Key String)
onKeydown constructor = createRawEvent "keydown" (keyInput constructor)

-- scroll

-- onFocus :: forall message. ToEvent message
-- onFocus = createEvent "focus"

-- onFocus' :: forall message. ToRawEvent message
-- onFocus' = createEventMessage "focus"

-- onBlur :: forall message. ToEvent message
-- onBlur = createEvent "blur"

-- onBlur' :: forall message. ToRawEvent message
-- onBlur' = createEventMessage "blur"



-- onKeydown' :: forall message. ToRawEvent message
-- onKeydown' = createEventMessage "keydown"

-- onKeypress :: forall message. ToSpecialEvent message (Tuple Key String)
-- onKeypress constructor = createRawEvent "keypress" (keyInput constructor)

-- onKeypress' :: forall message. ToRawEvent message
-- onKeypress' = createEventMessage "keypress"

-- onKeyup :: forall message. ToSpecialEvent message (Tuple Key String)
-- onKeyup constructor = createRawEvent "keyup" (keyInput constructor)

-- onKeyup' :: forall message. ToRawEvent message
-- onKeyup' = createEventMessage "keyup"

-- keyInput :: forall message . (Tuple Key String -> message) -> Event -> Effect message
-- keyInput constructor event = do
--         down <- key event
--         value <- nodeValue event
--         pure <<< constructor $ Tuple down value

-- onContextmenu :: forall message. ToEvent message
-- onContextmenu = createEvent "contextmenu"

-- onContextmenu' :: forall message. ToRawEvent message
-- onContextmenu' = createEventMessage "contextmenu"

-- onDblclick :: forall message. ToEvent message
-- onDblclick = createEvent "dblclick"

-- onDblclick' :: forall message. ToRawEvent message
-- onDblclick' = createEventMessage "dblclick"

-- onWheel :: forall message. ToEvent message
-- onWheel = createEvent "wheel"

-- onWheel' :: forall message. ToRawEvent message
-- onWheel' = createEventMessage "wheel"

-- onDrag :: forall message. ToEvent message
-- onDrag = createEvent "drag"

-- onDrag' :: forall message. ToRawEvent message
-- onDrag' = createEventMessage "drag"

-- onDragend :: forall message. ToEvent message
-- onDragend = createEvent "dragend"

-- onDragend' :: forall message. ToRawEvent message
-- onDragend' = createEventMessage "dragend"

-- onDragenter :: forall message. ToEvent message
-- onDragenter = createEvent "dragenter"

-- onDragenter' :: forall message. ToRawEvent message
-- onDragenter' = createEventMessage "dragenter"

-- onDragstart :: forall message. ToEvent message
-- onDragstart = createEvent "dragstart"

-- onDragstart' :: forall message. ToRawEvent message
-- onDragstart' = createEventMessage "dragstart"

-- onDragleave :: forall message. ToEvent message
-- onDragleave = createEvent "dragleave"

-- onDragleave' :: forall message. ToRawEvent message
-- onDragleave' = createEventMessage "dragleave"

-- onDragover :: forall message. ToEvent message
-- onDragover = createEvent "dragover"

-- onDragover' :: forall message. ToRawEvent message
-- onDragover' = createEventMessage "dragover"

-- onDrop :: forall message. ToEvent message
-- onDrop = createEvent "drop"

-- onDrop' :: forall message. ToRawEvent message
-- onDrop' = createEventMessage "drop"