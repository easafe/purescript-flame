--the version of Flame.HTML.Event that works on the window/document using signals
module Flame.Signal.Global where

-- scroll

-- onClick :: forall message. ToEvent message
-- onClick = createEvent "click"

-- onClick' :: forall message. ToRawEvent message
-- onClick' = createEventMessage "click"

-- onFocus :: forall message. ToEvent message
-- onFocus = createEvent "focus"

-- onFocus' :: forall message. ToRawEvent message
-- onFocus' = createEventMessage "focus"

-- onBlur :: forall message. ToEvent message
-- onBlur = createEvent "blur"

-- onBlur' :: forall message. ToRawEvent message
-- onBlur' = createEventMessage "blur"

-- onKeydown :: forall message. ToSpecialEvent message (Tuple Key String)
-- onKeydown constructor = createRawEvent "keydown" (keyInput constructor)

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