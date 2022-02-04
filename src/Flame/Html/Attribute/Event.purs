-- | Definition of HTML events that can be fired from views
module Flame.Html.Event (EventName, ToEvent, ToRawEvent, ToMaybeEvent, ToSpecialEvent, createEvent, createEventMessage, createRawEvent, onBlur, onBlur', onCheck, onClick, onClick', onChange, onChange', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onError, onError', onFocus, onFocus', onFocusin, onFocusin', onFocusout, onFocusout', onInput, onInput', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onMousedown, onMousedown', onMouseenter, onMouseenter', onMouseleave, onMouseleave', onMousemove, onMousemove', onMouseout, onMouseout', onMouseover, onMouseover', onMouseup, onMouseup', onReset, onReset', onScroll, onScroll', onSelect, onSelect', onSubmit, onSubmit', onWheel, onWheel') where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame.Types (NodeData, Key)
import Web.Event.Event (Event)

type EventName = String

type ToEvent message = message -> NodeData message

type ToRawEvent message = (Event -> message) -> NodeData message

type ToMaybeEvent message = (Event -> Maybe message) -> NodeData message

type ToSpecialEvent message t = (t -> message) -> NodeData message

--this way we dont need to worry about every possible element type
foreign import nodeValue_ :: EffectFn1 Event String
foreign import checkedValue_ :: EffectFn1 Event Boolean
foreign import preventDefault_ :: EffectFn1 Event Unit
foreign import key_ :: EffectFn1 Event Key
foreign import selection_ :: EffectFn1 Event String
foreign import createEvent_ :: forall message. EventName -> message -> (NodeData message)
foreign import createRawEvent_ :: forall message. EventName -> (Event -> Effect (Maybe message)) -> (NodeData message)

nodeValue :: Event -> Effect String
nodeValue = FU.runEffectFn1 nodeValue_

checkedValue :: Event -> Effect Boolean
checkedValue = FU.runEffectFn1 checkedValue_

preventDefault :: Event -> Effect Unit
preventDefault = FU.runEffectFn1 preventDefault_

key :: Event -> Effect String
key = FU.runEffectFn1 key_

selection :: Event -> Effect String
selection = FU.runEffectFn1 selection_

-- | Raises the given `message` for the event
createEvent :: forall message. EventName -> message -> NodeData message
createEvent name message = createEvent_ name message

-- | Raises the given `message` for the given event, but also supplies the event itself
createRawEvent :: forall message. EventName -> (Event -> Effect (Maybe message)) -> NodeData message
createRawEvent name handler = createRawEvent_ name handler

-- | Helper for `message`s that expect an event
createEventMessage :: forall message. EventName -> (Event -> message) -> NodeData message
createEventMessage eventName constructor = createRawEvent eventName (pure <<< Just <<< constructor)

onScroll :: forall message. ToEvent message
onScroll = createEvent "scroll"

onScroll' :: forall message. ToRawEvent message
onScroll' = createEventMessage "scroll"

onClick :: forall message. ToEvent message
onClick = createEvent "click"

onClick' :: forall message. ToRawEvent message
onClick' = createEventMessage "click"

onChange :: forall message. ToEvent message
onChange = createEvent "change"

onChange' :: forall message. ToRawEvent message
onChange' = createEventMessage "change"

-- | This event fires when the value of an input, select, textarea, contenteditable or designMode on elements changes
onInput :: forall message. ToSpecialEvent message String
onInput constructor = createRawEvent "input" handler
      where handler event = Just <<< constructor <$> nodeValue event

onInput' :: forall message. ToRawEvent message
onInput' = createEventMessage "input"

-- | Helper for `input` event of checkboxes and radios
onCheck :: forall message. ToSpecialEvent message Boolean
onCheck constructor = createRawEvent "input" handler
      where   handler event = Just <<< constructor <$> checkedValue event

onSubmit :: forall message. ToEvent message
onSubmit message = createRawEvent "submit" handler
      where handler event = do
                  preventDefault event
                  pure $ Just message

onSubmit' :: forall message. ToRawEvent message
onSubmit' constructor = createRawEvent "submit" handler
      where handler event = do
                  preventDefault event
                  pure <<< Just $ constructor event

onFocus :: forall message. ToEvent message
onFocus = createEvent "focus"

onFocus' :: forall message. ToRawEvent message
onFocus' = createEventMessage "focus"

onFocusin :: forall message. ToEvent message
onFocusin = createEvent "focusin"

onFocusin' :: forall message. ToRawEvent message
onFocusin' = createEventMessage "focusin"

onFocusout :: forall message. ToEvent message
onFocusout = createEvent "focusout"

onFocusout' :: forall message. ToRawEvent message
onFocusout' = createEventMessage "focusout"

onBlur :: forall message. ToEvent message
onBlur = createEvent "blur"

onBlur' :: forall message. ToRawEvent message
onBlur' = createEventMessage "blur"

onReset :: forall message. ToEvent message
onReset = createEvent "reset"

onReset' :: forall message. ToRawEvent message
onReset' = createEventMessage "reset"

onKeydown :: forall message. ToSpecialEvent message (Tuple Key String)
onKeydown constructor = createRawEvent "keydown" (keyInput constructor)

onKeydown' :: forall message. ToRawEvent message
onKeydown' = createEventMessage "keydown"

onKeypress :: forall message. ToSpecialEvent message (Tuple Key String)
onKeypress constructor = createRawEvent "keypress" (keyInput constructor)

onKeypress' :: forall message. ToRawEvent message
onKeypress' = createEventMessage "keypress"

onKeyup :: forall message. ToSpecialEvent message (Tuple Key String)
onKeyup constructor = createRawEvent "keyup" (keyInput constructor)

onKeyup' :: forall message. ToRawEvent message
onKeyup' = createEventMessage "keyup"

keyInput :: forall message . (Tuple Key String -> message) -> Event -> Effect (Maybe message)
keyInput constructor event = do
      down <- key event
      value <- nodeValue event
      pure <<< Just <<< constructor $ Tuple down value

onContextmenu :: forall message. ToEvent message
onContextmenu = createEvent "contextmenu"

onContextmenu' :: forall message. ToRawEvent message
onContextmenu' = createEventMessage "contextmenu"

onDblclick :: forall message. ToEvent message
onDblclick = createEvent "dblclick"

onDblclick' :: forall message. ToRawEvent message
onDblclick' = createEventMessage "dblclick"

onMousedown :: forall message. ToEvent message
onMousedown = createEvent "mousedown"

onMousedown' :: forall message. ToRawEvent message
onMousedown' = createEventMessage "mousedown"

onMouseenter :: forall message. ToEvent message
onMouseenter = createEvent "mouseenter"

onMouseenter' :: forall message. ToRawEvent message
onMouseenter' = createEventMessage "mouseenter"

onMouseleave :: forall message. ToEvent message
onMouseleave = createEvent "mouseleave"

onMouseleave' :: forall message. ToRawEvent message
onMouseleave' = createEventMessage "mouseleave"

onMousemove :: forall message. ToEvent message
onMousemove = createEvent "mousemove"

onMousemove' :: forall message. ToRawEvent message
onMousemove' = createEventMessage "mousemove"

onMouseover :: forall message. ToEvent message
onMouseover = createEvent "mouseover"

onMouseover' :: forall message. ToRawEvent message
onMouseover' = createEventMessage "mouseover"

onMouseout :: forall message. ToEvent message
onMouseout = createEvent "mouseout"

onMouseout' :: forall message. ToRawEvent message
onMouseout' = createEventMessage "mouseout"

onMouseup :: forall message. ToEvent message
onMouseup = createEvent "mouseup"

onMouseup' :: forall message. ToRawEvent message
onMouseup' = createEventMessage "mouseup"

onSelect :: forall message. ToSpecialEvent message String
onSelect constructor = createRawEvent "select" handler
      where   handler event = Just <<< constructor <$> selection event

onSelect' :: forall message. ToRawEvent message
onSelect' = createEventMessage "select"

onWheel :: forall message. ToEvent message
onWheel = createEvent "wheel"

onWheel' :: forall message. ToRawEvent message
onWheel' = createEventMessage "wheel"

onDrag :: forall message. ToEvent message
onDrag = createEvent "drag"

onDrag' :: forall message. ToRawEvent message
onDrag' = createEventMessage "drag"

onDragend :: forall message. ToEvent message
onDragend = createEvent "dragend"

onDragend' :: forall message. ToRawEvent message
onDragend' = createEventMessage "dragend"

onDragenter :: forall message. ToEvent message
onDragenter = createEvent "dragenter"

onDragenter' :: forall message. ToRawEvent message
onDragenter' = createEventMessage "dragenter"

onDragstart :: forall message. ToEvent message
onDragstart = createEvent "dragstart"

onDragstart' :: forall message. ToRawEvent message
onDragstart' = createEventMessage "dragstart"

onDragleave :: forall message. ToEvent message
onDragleave = createEvent "dragleave"

onDragleave' :: forall message. ToRawEvent message
onDragleave' = createEventMessage "dragleave"

onDragover :: forall message. ToEvent message
onDragover = createEvent "dragover"

onDragover' :: forall message. ToRawEvent message
onDragover' = createEventMessage "dragover"

onDrop :: forall message. ToEvent message
onDrop = createEvent "drop"

onDrop' :: forall message. ToRawEvent message
onDrop' = createEventMessage "drop"

onError :: forall message. ToEvent message
onError = createEvent "error"

onError' :: forall message. ToRawEvent message
onError' = createEventMessage "error"