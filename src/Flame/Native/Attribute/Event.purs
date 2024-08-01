-- | Definition of react native events that can be fired from views
module Flame.Native.Event (EventName, ToEvent, ToRawEvent, ToMaybeEvent, ToSpecialEvent, createEvent, createEventMessage, createRawEvent, onBlur, onBlur', onCheck, onClick, onClick', onChange, onChange', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onError, onError', onFocus, onFocus', onFocusin, onFocusin', onFocusout, onFocusout', onInput, onInput', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onMousedown, onMousedown', onMouseenter, onMouseenter', onMouseleave, onMouseleave', onMousemove, onMousemove', onMouseout, onMouseout', onLoad, onLoad', onUnload, onUnload', onMouseover, onMouseover', onMouseup, onMouseup', onReset, onReset', onScroll, onScroll', onSelect, onSelect', onSubmit, onSubmit', onWheel, onWheel') where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame.Types (NodeData, Key)
import Web.Event.Event (Event)

type EventName = String

type ToEvent message = message → NodeData message

type ToRawEvent message = (Event → message) → NodeData message

type ToMaybeEvent message = (Event → Maybe message) → NodeData message

type ToSpecialEvent message t = (t → message) → NodeData message

--this way we dont need to worry about every possible element type
foreign import nodeValue_ ∷ EffectFn1 Event String
foreign import checkedValue_ ∷ EffectFn1 Event Boolean
foreign import preventDefault_ ∷ EffectFn1 Event Unit
foreign import key_ ∷ EffectFn1 Event Key
foreign import selection_ ∷ EffectFn1 Event String
foreign import createEvent_ ∷ ∀ message. EventName → message → (NodeData message)
foreign import createRawEvent_ ∷ ∀ message. EventName → (Event → Effect (Maybe message)) → (NodeData message)

nodeValue ∷ Event → Effect String
nodeValue = FU.runEffectFn1 nodeValue_

checkedValue ∷ Event → Effect Boolean
checkedValue = FU.runEffectFn1 checkedValue_

preventDefault ∷ Event → Effect Unit
preventDefault = FU.runEffectFn1 preventDefault_

key ∷ Event → Effect String
key = FU.runEffectFn1 key_

selection ∷ Event → Effect String
selection = FU.runEffectFn1 selection_

-- | Raises the given `message` for the event
createEvent ∷ ∀ message. EventName → message → NodeData message
createEvent name message = createEvent_ name message

-- | Raises the given `message` for the given event, but also supplies the event itself
createRawEvent ∷ ∀ message. EventName → (Event → Effect (Maybe message)) → NodeData message
createRawEvent name handler = createRawEvent_ name handler

-- | Helper for `message`s that expect an event
createEventMessage ∷ ∀ message. EventName → (Event → message) → NodeData message
createEventMessage eventName constructor = createRawEvent eventName (pure <<< Just <<< constructor)

onScroll ∷ ∀ message. ToEvent message
onScroll = createEvent "scroll"

onScroll' ∷ ∀ message. ToRawEvent message
onScroll' = createEventMessage "scroll"

onClick ∷ ∀ message. ToEvent message
onClick = createEvent "onPress"

onClick' ∷ ∀ message. ToRawEvent message
onClick' = createEventMessage "click"

onLoad ∷ ∀ message. ToEvent message
onLoad = createEvent "load"

onLoad' ∷ ∀ message. ToRawEvent message
onLoad' = createEventMessage "load"

onUnload ∷ ∀ message. ToEvent message
onUnload = createEvent "unload"

onUnload' ∷ ∀ message. ToRawEvent message
onUnload' = createEventMessage "unload"

onChange ∷ ∀ message. ToEvent message
onChange = createEvent "change"

onChange' ∷ ∀ message. ToRawEvent message
onChange' = createEventMessage "change"

-- | This event fires when the value of an input, select, textarea, contenteditable or designMode on elements changes
onInput ∷ ∀ message. ToSpecialEvent message String
onInput constructor = createRawEvent "input" handler
      where
      handler event = Just <<< constructor <$> nodeValue event

onInput' ∷ ∀ message. ToRawEvent message
onInput' = createEventMessage "input"

-- | Helper for `input` event of checkboxes and radios
onCheck ∷ ∀ message. ToSpecialEvent message Boolean
onCheck constructor = createRawEvent "input" handler
      where
      handler event = Just <<< constructor <$> checkedValue event

onSubmit ∷ ∀ message. ToEvent message
onSubmit message = createRawEvent "submit" handler
      where
      handler event = do
            preventDefault event
            pure $ Just message

onSubmit' ∷ ∀ message. ToRawEvent message
onSubmit' constructor = createRawEvent "submit" handler
      where
      handler event = do
            preventDefault event
            pure <<< Just $ constructor event

onFocus ∷ ∀ message. ToEvent message
onFocus = createEvent "focus"

onFocus' ∷ ∀ message. ToRawEvent message
onFocus' = createEventMessage "focus"

onFocusin ∷ ∀ message. ToEvent message
onFocusin = createEvent "focusin"

onFocusin' ∷ ∀ message. ToRawEvent message
onFocusin' = createEventMessage "focusin"

onFocusout ∷ ∀ message. ToEvent message
onFocusout = createEvent "focusout"

onFocusout' ∷ ∀ message. ToRawEvent message
onFocusout' = createEventMessage "focusout"

onBlur ∷ ∀ message. ToEvent message
onBlur = createEvent "blur"

onBlur' ∷ ∀ message. ToRawEvent message
onBlur' = createEventMessage "blur"

onReset ∷ ∀ message. ToEvent message
onReset = createEvent "reset"

onReset' ∷ ∀ message. ToRawEvent message
onReset' = createEventMessage "reset"

onKeydown ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeydown constructor = createRawEvent "keydown" (keyInput constructor)

onKeydown' ∷ ∀ message. ToRawEvent message
onKeydown' = createEventMessage "keydown"

onKeypress ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeypress constructor = createRawEvent "keypress" (keyInput constructor)

onKeypress' ∷ ∀ message. ToRawEvent message
onKeypress' = createEventMessage "keypress"

onKeyup ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeyup constructor = createRawEvent "keyup" (keyInput constructor)

onKeyup' ∷ ∀ message. ToRawEvent message
onKeyup' = createEventMessage "keyup"

keyInput ∷ ∀ message. (Tuple Key String → message) → Event → Effect (Maybe message)
keyInput constructor event = do
      down ← key event
      value ← nodeValue event
      pure <<< Just <<< constructor $ Tuple down value

onContextmenu ∷ ∀ message. ToEvent message
onContextmenu = createEvent "contextmenu"

onContextmenu' ∷ ∀ message. ToRawEvent message
onContextmenu' = createEventMessage "contextmenu"

onDblclick ∷ ∀ message. ToEvent message
onDblclick = createEvent "dblclick"

onDblclick' ∷ ∀ message. ToRawEvent message
onDblclick' = createEventMessage "dblclick"

onMousedown ∷ ∀ message. ToEvent message
onMousedown = createEvent "mousedown"

onMousedown' ∷ ∀ message. ToRawEvent message
onMousedown' = createEventMessage "mousedown"

onMouseenter ∷ ∀ message. ToEvent message
onMouseenter = createEvent "mouseenter"

onMouseenter' ∷ ∀ message. ToRawEvent message
onMouseenter' = createEventMessage "mouseenter"

onMouseleave ∷ ∀ message. ToEvent message
onMouseleave = createEvent "mouseleave"

onMouseleave' ∷ ∀ message. ToRawEvent message
onMouseleave' = createEventMessage "mouseleave"

onMousemove ∷ ∀ message. ToEvent message
onMousemove = createEvent "mousemove"

onMousemove' ∷ ∀ message. ToRawEvent message
onMousemove' = createEventMessage "mousemove"

onMouseover ∷ ∀ message. ToEvent message
onMouseover = createEvent "mouseover"

onMouseover' ∷ ∀ message. ToRawEvent message
onMouseover' = createEventMessage "mouseover"

onMouseout ∷ ∀ message. ToEvent message
onMouseout = createEvent "mouseout"

onMouseout' ∷ ∀ message. ToRawEvent message
onMouseout' = createEventMessage "mouseout"

onMouseup ∷ ∀ message. ToEvent message
onMouseup = createEvent "mouseup"

onMouseup' ∷ ∀ message. ToRawEvent message
onMouseup' = createEventMessage "mouseup"

onSelect ∷ ∀ message. ToSpecialEvent message String
onSelect constructor = createRawEvent "select" handler
      where
      handler event = Just <<< constructor <$> selection event

onSelect' ∷ ∀ message. ToRawEvent message
onSelect' = createEventMessage "select"

onWheel ∷ ∀ message. ToEvent message
onWheel = createEvent "wheel"

onWheel' ∷ ∀ message. ToRawEvent message
onWheel' = createEventMessage "wheel"

onDrag ∷ ∀ message. ToEvent message
onDrag = createEvent "drag"

onDrag' ∷ ∀ message. ToRawEvent message
onDrag' = createEventMessage "drag"

onDragend ∷ ∀ message. ToEvent message
onDragend = createEvent "dragend"

onDragend' ∷ ∀ message. ToRawEvent message
onDragend' = createEventMessage "dragend"

onDragenter ∷ ∀ message. ToEvent message
onDragenter = createEvent "dragenter"

onDragenter' ∷ ∀ message. ToRawEvent message
onDragenter' = createEventMessage "dragenter"

onDragstart ∷ ∀ message. ToEvent message
onDragstart = createEvent "dragstart"

onDragstart' ∷ ∀ message. ToRawEvent message
onDragstart' = createEventMessage "dragstart"

onDragleave ∷ ∀ message. ToEvent message
onDragleave = createEvent "dragleave"

onDragleave' ∷ ∀ message. ToRawEvent message
onDragleave' = createEventMessage "dragleave"

onDragover ∷ ∀ message. ToEvent message
onDragover = createEvent "dragover"

onDragover' ∷ ∀ message. ToRawEvent message
onDragover' = createEventMessage "dragover"

onDrop ∷ ∀ message. ToEvent message
onDrop = createEvent "drop"

onDrop' ∷ ∀ message. ToRawEvent message
onDrop' = createEventMessage "drop"

onError ∷ ∀ message. ToEvent message
onError = createEvent "error"

onError' ∷ ∀ message. ToRawEvent message
onError' = createEventMessage "error"