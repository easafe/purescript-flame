-- | Definition of HTML events that can be fired from views
module Flame.Html.Event
      ( ToEvent
      , ToRawEvent
      , ToMaybeEvent
      , ToSpecialEvent
      , createEvent
      , createEventMessage
      , createRawEvent
      , nodeValue
      , checkedValue
      , preventDefault
      , pressedKey
      , selection
      , onScroll
      , onScroll'
      , onScroll_
      , onClick
      , onClick'
      , onClick_
      , onLoad
      , onLoad'
      , onLoad_
      , onUnload
      , onUnload'
      , onUnload_
      , onChange
      , onChange'
      , onChange_
      , onInput
      , onInput'
      , onInput_
      , onCheck
      , onSubmit
      , onSubmit'
      , onSubmit_
      , onFocus
      , onFocus'
      , onFocus_
      , onFocusin
      , onFocusin'
      , onFocusin_
      , onFocusout
      , onFocusout'
      , onFocusout_
      , onBlur
      , onBlur'
      , onBlur_
      , onReset
      , onReset'
      , onReset_
      , onKeydown
      , onKeydown'
      , onKeydown_
      , onKeypress
      , onKeypress'
      , onKeypress_
      , onKeyup
      , onKeyup'
      , onKeyup_
      , onContextmenu
      , onContextmenu'
      , onContextmenu_
      , onDblclick
      , onDblclick'
      , onDblclick_
      , onMousedown
      , onMousedown'
      , onMousedown_
      , onMouseenter
      , onMouseenter'
      , onMouseenter_
      , onMouseleave
      , onMouseleave'
      , onMouseleave_
      , onMousemove
      , onMousemove'
      , onMousemove_
      , onMouseover
      , onMouseover'
      , onMouseover_
      , onMouseout
      , onMouseout'
      , onMouseout_
      , onMouseup
      , onMouseup'
      , onMouseup_
      , onSelect
      , onSelect'
      , onSelect_
      , onWheel
      , onWheel'
      , onWheel_
      , onDrag
      , onDrag'
      , onDrag_
      , onDragend
      , onDragend'
      , onDragend_
      , onDragenter
      , onDragenter'
      , onDragenter_
      , onDragstart
      , onDragstart'
      , onDragstart_
      , onDragleave
      , onDragleave'
      , onDragleave_
      , onDragover
      , onDragover'
      , onDragover_
      , onDrop
      , onDrop'
      , onDrop_
      , onError
      , onError'
      , onError_
      ) where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as FU
import Flame.Types (EventName, Key, NodeData)
import Web.Event.Event (Event)

-- | Event handler that raises a fixed message
type ToEvent message = message → NodeData message

-- | Event handler that builds a message from the DOM event
type ToRawEvent message = (Event → message) → NodeData message

-- | Event handler that runs effects and may not raise a message
type ToMaybeEvent message = (Event → Effect (Maybe message)) → NodeData message

-- | Event handler that builds a message from a value extracted from the event, e.g. the input value
type ToSpecialEvent message t = (t → message) → NodeData message

--this way we dont need to worry about every possible element type
foreign import nodeValue_ ∷ EffectFn1 Event String
foreign import checkedValue_ ∷ EffectFn1 Event Boolean
foreign import preventDefault_ ∷ EffectFn1 Event Unit
foreign import key_ ∷ EffectFn1 Event Key
foreign import selection_ ∷ EffectFn1 Event String
foreign import createEvent_ ∷ ∀ message. EventName → message → (NodeData message)
foreign import createRawEvent_ ∷ ∀ message. EventName → (Event → Effect (Maybe message)) → (NodeData message)

-- | Current value of the node that fired the event
nodeValue ∷ Event → Effect String
nodeValue = FU.runEffectFn1 nodeValue_

-- | Whether the checkbox or radio that fired the event is checked
checkedValue ∷ Event → Effect Boolean
checkedValue = FU.runEffectFn1 checkedValue_

-- | Prevents the default action of the event
preventDefault ∷ Event → Effect Unit
preventDefault = FU.runEffectFn1 preventDefault_

-- | Key pressed for keyboard events, empty otherwise
pressedKey ∷ Event → Effect String
pressedKey = FU.runEffectFn1 key_

-- | Selected text of the input or textarea that fired the event, empty otherwise
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

-- | Raises the given message when the `scroll` event fires
onScroll ∷ ∀ message. ToEvent message
onScroll = createEvent "scroll"

-- | Raises a message built from the `scroll` event
onScroll' ∷ ∀ message. ToRawEvent message
onScroll' = createEventMessage "scroll"

-- | Handles the `scroll` event with an effectful handler that may return `Nothing`
onScroll_ ∷ ∀ message. ToMaybeEvent message
onScroll_ = createRawEvent "scroll"

-- | Raises the given message when the `click` event fires
onClick ∷ ∀ message. ToEvent message
onClick = createEvent "click"

-- | Raises a message built from the `click` event
onClick' ∷ ∀ message. ToRawEvent message
onClick' = createEventMessage "click"

-- | Handles the `click` event with an effectful handler that may return `Nothing`
onClick_ ∷ ∀ message. ToMaybeEvent message
onClick_ = createRawEvent "click"

-- | Raises the given message when the `load` event fires
onLoad ∷ ∀ message. ToEvent message
onLoad = createEvent "load"

-- | Raises a message built from the `load` event
onLoad' ∷ ∀ message. ToRawEvent message
onLoad' = createEventMessage "load"

-- | Handles the `load` event with an effectful handler that may return `Nothing`
onLoad_ ∷ ∀ message. ToMaybeEvent message
onLoad_ = createRawEvent "load"

-- | Raises the given message when the `unload` event fires
onUnload ∷ ∀ message. ToEvent message
onUnload = createEvent "unload"

-- | Raises a message built from the `unload` event
onUnload' ∷ ∀ message. ToRawEvent message
onUnload' = createEventMessage "unload"

-- | Handles the `unload` event with an effectful handler that may return `Nothing`
onUnload_ ∷ ∀ message. ToMaybeEvent message
onUnload_ = createRawEvent "unload"

-- | Raises the given message when the `change` event fires
onChange ∷ ∀ message. ToEvent message
onChange = createEvent "change"

-- | Raises a message built from the `change` event
onChange' ∷ ∀ message. ToRawEvent message
onChange' = createEventMessage "change"

-- | Handles the `change` event with an effectful handler that may return `Nothing`
onChange_ ∷ ∀ message. ToMaybeEvent message
onChange_ = createRawEvent "change"

-- | This event fires when the value of an input, select, textarea, contenteditable or designMode on elements changes
onInput ∷ ∀ message. ToSpecialEvent message String
onInput constructor = createRawEvent "input" handler
      where
      handler event = Just <<< constructor <$> nodeValue event

-- | Raises a message built from the `input` event
onInput' ∷ ∀ message. ToRawEvent message
onInput' = createEventMessage "input"

-- | Handles the `input` event with an effectful handler that may return `Nothing`
onInput_ ∷ ∀ message. ToMaybeEvent message
onInput_ = createRawEvent "input"

-- | Helper for `input` event of checkboxes and radios
onCheck ∷ ∀ message. ToSpecialEvent message Boolean
onCheck constructor = createRawEvent "input" handler
      where
      handler event = Just <<< constructor <$> checkedValue event

-- | Raises the given message when the `submit` event fires, preventing the default form submission
onSubmit ∷ ∀ message. ToEvent message
onSubmit message = createRawEvent "submit" handler
      where
      handler event = do
            preventDefault event
            pure $ Just message

-- | Raises a message built from the `submit` event, preventing the default form submission
onSubmit' ∷ ∀ message. ToRawEvent message
onSubmit' constructor = createRawEvent "submit" handler
      where
      handler event = do
            preventDefault event
            pure <<< Just $ constructor event

-- | Handles the `submit` event with an effectful handler that may return `Nothing`; the default action is not prevented
onSubmit_ ∷ ∀ message. ToMaybeEvent message
onSubmit_ = createRawEvent "submit"

-- | Raises the given message when the `focus` event fires
onFocus ∷ ∀ message. ToEvent message
onFocus = createEvent "focus"

-- | Raises a message built from the `focus` event
onFocus' ∷ ∀ message. ToRawEvent message
onFocus' = createEventMessage "focus"

-- | Handles the `focus` event with an effectful handler that may return `Nothing`
onFocus_ ∷ ∀ message. ToMaybeEvent message
onFocus_ = createRawEvent "focus"

-- | Raises the given message when the `focusin` event fires
onFocusin ∷ ∀ message. ToEvent message
onFocusin = createEvent "focusin"

-- | Raises a message built from the `focusin` event
onFocusin' ∷ ∀ message. ToRawEvent message
onFocusin' = createEventMessage "focusin"

-- | Handles the `focusin` event with an effectful handler that may return `Nothing`
onFocusin_ ∷ ∀ message. ToMaybeEvent message
onFocusin_ = createRawEvent "focusin"

-- | Raises the given message when the `focusout` event fires
onFocusout ∷ ∀ message. ToEvent message
onFocusout = createEvent "focusout"

-- | Raises a message built from the `focusout` event
onFocusout' ∷ ∀ message. ToRawEvent message
onFocusout' = createEventMessage "focusout"

-- | Handles the `focusout` event with an effectful handler that may return `Nothing`
onFocusout_ ∷ ∀ message. ToMaybeEvent message
onFocusout_ = createRawEvent "focusout"

-- | Raises the given message when the `blur` event fires
onBlur ∷ ∀ message. ToEvent message
onBlur = createEvent "blur"

-- | Raises a message built from the `blur` event
onBlur' ∷ ∀ message. ToRawEvent message
onBlur' = createEventMessage "blur"

-- | Handles the `blur` event with an effectful handler that may return `Nothing`
onBlur_ ∷ ∀ message. ToMaybeEvent message
onBlur_ = createRawEvent "blur"

-- | Raises the given message when the `reset` event fires
onReset ∷ ∀ message. ToEvent message
onReset = createEvent "reset"

-- | Raises a message built from the `reset` event
onReset' ∷ ∀ message. ToRawEvent message
onReset' = createEventMessage "reset"

-- | Handles the `reset` event with an effectful handler that may return `Nothing`
onReset_ ∷ ∀ message. ToMaybeEvent message
onReset_ = createRawEvent "reset"

-- | Raises a message built from the key pressed and the current value of the node when the `keydown` event fires
onKeydown ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeydown constructor = createRawEvent "keydown" (keyInput constructor)

-- | Raises a message built from the `keydown` event
onKeydown' ∷ ∀ message. ToRawEvent message
onKeydown' = createEventMessage "keydown"

-- | Handles the `keydown` event with an effectful handler that may return `Nothing`
onKeydown_ ∷ ∀ message. ToMaybeEvent message
onKeydown_ = createRawEvent "keydown"

-- | Raises a message built from the key pressed and the current value of the node when the `keypress` event fires
onKeypress ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeypress constructor = createRawEvent "keypress" (keyInput constructor)

-- | Raises a message built from the `keypress` event
onKeypress' ∷ ∀ message. ToRawEvent message
onKeypress' = createEventMessage "keypress"

-- | Handles the `keypress` event with an effectful handler that may return `Nothing`
onKeypress_ ∷ ∀ message. ToMaybeEvent message
onKeypress_ = createRawEvent "keypress"

-- | Raises a message built from the key pressed and the current value of the node when the `keyup` event fires
onKeyup ∷ ∀ message. ToSpecialEvent message (Tuple Key String)
onKeyup constructor = createRawEvent "keyup" (keyInput constructor)

-- | Raises a message built from the `keyup` event
onKeyup' ∷ ∀ message. ToRawEvent message
onKeyup' = createEventMessage "keyup"

-- | Handles the `keyup` event with an effectful handler that may return `Nothing`
onKeyup_ ∷ ∀ message. ToMaybeEvent message
onKeyup_ = createRawEvent "keyup"

-- | Builds a message from the key pressed and the current value of the node
keyInput ∷ ∀ message. (Tuple Key String → message) → Event → Effect (Maybe message)
keyInput constructor event = do
      down ← pressedKey event
      value ← nodeValue event
      pure <<< Just <<< constructor $ Tuple down value

-- | Raises the given message when the `contextmenu` event fires
onContextmenu ∷ ∀ message. ToEvent message
onContextmenu = createEvent "contextmenu"

-- | Raises a message built from the `contextmenu` event
onContextmenu' ∷ ∀ message. ToRawEvent message
onContextmenu' = createEventMessage "contextmenu"

-- | Handles the `contextmenu` event with an effectful handler that may return `Nothing`
onContextmenu_ ∷ ∀ message. ToMaybeEvent message
onContextmenu_ = createRawEvent "contextmenu"

-- | Raises the given message when the `dblclick` event fires
onDblclick ∷ ∀ message. ToEvent message
onDblclick = createEvent "dblclick"

-- | Raises a message built from the `dblclick` event
onDblclick' ∷ ∀ message. ToRawEvent message
onDblclick' = createEventMessage "dblclick"

-- | Handles the `dblclick` event with an effectful handler that may return `Nothing`
onDblclick_ ∷ ∀ message. ToMaybeEvent message
onDblclick_ = createRawEvent "dblclick"

-- | Raises the given message when the `mousedown` event fires
onMousedown ∷ ∀ message. ToEvent message
onMousedown = createEvent "mousedown"

-- | Raises a message built from the `mousedown` event
onMousedown' ∷ ∀ message. ToRawEvent message
onMousedown' = createEventMessage "mousedown"

-- | Handles the `mousedown` event with an effectful handler that may return `Nothing`
onMousedown_ ∷ ∀ message. ToMaybeEvent message
onMousedown_ = createRawEvent "mousedown"

-- | Raises the given message when the `mouseenter` event fires
onMouseenter ∷ ∀ message. ToEvent message
onMouseenter = createEvent "mouseenter"

-- | Raises a message built from the `mouseenter` event
onMouseenter' ∷ ∀ message. ToRawEvent message
onMouseenter' = createEventMessage "mouseenter"

-- | Handles the `mouseenter` event with an effectful handler that may return `Nothing`
onMouseenter_ ∷ ∀ message. ToMaybeEvent message
onMouseenter_ = createRawEvent "mouseenter"

-- | Raises the given message when the `mouseleave` event fires
onMouseleave ∷ ∀ message. ToEvent message
onMouseleave = createEvent "mouseleave"

-- | Raises a message built from the `mouseleave` event
onMouseleave' ∷ ∀ message. ToRawEvent message
onMouseleave' = createEventMessage "mouseleave"

-- | Handles the `mouseleave` event with an effectful handler that may return `Nothing`
onMouseleave_ ∷ ∀ message. ToMaybeEvent message
onMouseleave_ = createRawEvent "mouseleave"

-- | Raises the given message when the `mousemove` event fires
onMousemove ∷ ∀ message. ToEvent message
onMousemove = createEvent "mousemove"

-- | Raises a message built from the `mousemove` event
onMousemove' ∷ ∀ message. ToRawEvent message
onMousemove' = createEventMessage "mousemove"

-- | Handles the `mousemove` event with an effectful handler that may return `Nothing`
onMousemove_ ∷ ∀ message. ToMaybeEvent message
onMousemove_ = createRawEvent "mousemove"

-- | Raises the given message when the `mouseover` event fires
onMouseover ∷ ∀ message. ToEvent message
onMouseover = createEvent "mouseover"

-- | Raises a message built from the `mouseover` event
onMouseover' ∷ ∀ message. ToRawEvent message
onMouseover' = createEventMessage "mouseover"

-- | Handles the `mouseover` event with an effectful handler that may return `Nothing`
onMouseover_ ∷ ∀ message. ToMaybeEvent message
onMouseover_ = createRawEvent "mouseover"

-- | Raises the given message when the `mouseout` event fires
onMouseout ∷ ∀ message. ToEvent message
onMouseout = createEvent "mouseout"

-- | Raises a message built from the `mouseout` event
onMouseout' ∷ ∀ message. ToRawEvent message
onMouseout' = createEventMessage "mouseout"

-- | Handles the `mouseout` event with an effectful handler that may return `Nothing`
onMouseout_ ∷ ∀ message. ToMaybeEvent message
onMouseout_ = createRawEvent "mouseout"

-- | Raises the given message when the `mouseup` event fires
onMouseup ∷ ∀ message. ToEvent message
onMouseup = createEvent "mouseup"

-- | Raises a message built from the `mouseup` event
onMouseup' ∷ ∀ message. ToRawEvent message
onMouseup' = createEventMessage "mouseup"

-- | Handles the `mouseup` event with an effectful handler that may return `Nothing`
onMouseup_ ∷ ∀ message. ToMaybeEvent message
onMouseup_ = createRawEvent "mouseup"

-- | Raises a message built from the text selected in the node when the `select` event fires
onSelect ∷ ∀ message. ToSpecialEvent message String
onSelect constructor = createRawEvent "select" handler
      where
      handler event = Just <<< constructor <$> selection event

-- | Raises a message built from the `select` event
onSelect' ∷ ∀ message. ToRawEvent message
onSelect' = createEventMessage "select"

-- | Handles the `select` event with an effectful handler that may return `Nothing`
onSelect_ ∷ ∀ message. ToMaybeEvent message
onSelect_ = createRawEvent "select"

-- | Raises the given message when the `wheel` event fires
onWheel ∷ ∀ message. ToEvent message
onWheel = createEvent "wheel"

-- | Raises a message built from the `wheel` event
onWheel' ∷ ∀ message. ToRawEvent message
onWheel' = createEventMessage "wheel"

-- | Handles the `wheel` event with an effectful handler that may return `Nothing`
onWheel_ ∷ ∀ message. ToMaybeEvent message
onWheel_ = createRawEvent "wheel"

-- | Raises the given message when the `drag` event fires
onDrag ∷ ∀ message. ToEvent message
onDrag = createEvent "drag"

-- | Raises a message built from the `drag` event
onDrag' ∷ ∀ message. ToRawEvent message
onDrag' = createEventMessage "drag"

-- | Handles the `drag` event with an effectful handler that may return `Nothing`
onDrag_ ∷ ∀ message. ToMaybeEvent message
onDrag_ = createRawEvent "drag"

-- | Raises the given message when the `dragend` event fires
onDragend ∷ ∀ message. ToEvent message
onDragend = createEvent "dragend"

-- | Raises a message built from the `dragend` event
onDragend' ∷ ∀ message. ToRawEvent message
onDragend' = createEventMessage "dragend"

-- | Handles the `dragend` event with an effectful handler that may return `Nothing`
onDragend_ ∷ ∀ message. ToMaybeEvent message
onDragend_ = createRawEvent "dragend"

-- | Raises the given message when the `dragenter` event fires
onDragenter ∷ ∀ message. ToEvent message
onDragenter = createEvent "dragenter"

-- | Raises a message built from the `dragenter` event
onDragenter' ∷ ∀ message. ToRawEvent message
onDragenter' = createEventMessage "dragenter"

-- | Handles the `dragenter` event with an effectful handler that may return `Nothing`
onDragenter_ ∷ ∀ message. ToMaybeEvent message
onDragenter_ = createRawEvent "dragenter"

-- | Raises the given message when the `dragstart` event fires
onDragstart ∷ ∀ message. ToEvent message
onDragstart = createEvent "dragstart"

-- | Raises a message built from the `dragstart` event
onDragstart' ∷ ∀ message. ToRawEvent message
onDragstart' = createEventMessage "dragstart"

-- | Handles the `dragstart` event with an effectful handler that may return `Nothing`
onDragstart_ ∷ ∀ message. ToMaybeEvent message
onDragstart_ = createRawEvent "dragstart"

-- | Raises the given message when the `dragleave` event fires
onDragleave ∷ ∀ message. ToEvent message
onDragleave = createEvent "dragleave"

-- | Raises a message built from the `dragleave` event
onDragleave' ∷ ∀ message. ToRawEvent message
onDragleave' = createEventMessage "dragleave"

-- | Handles the `dragleave` event with an effectful handler that may return `Nothing`
onDragleave_ ∷ ∀ message. ToMaybeEvent message
onDragleave_ = createRawEvent "dragleave"

-- | Raises the given message when the `dragover` event fires
onDragover ∷ ∀ message. ToEvent message
onDragover = createEvent "dragover"

-- | Raises a message built from the `dragover` event
onDragover' ∷ ∀ message. ToRawEvent message
onDragover' = createEventMessage "dragover"

-- | Handles the `dragover` event with an effectful handler that may return `Nothing`
onDragover_ ∷ ∀ message. ToMaybeEvent message
onDragover_ = createRawEvent "dragover"

-- | Raises the given message when the `drop` event fires
onDrop ∷ ∀ message. ToEvent message
onDrop = createEvent "drop"

-- | Raises a message built from the `drop` event
onDrop' ∷ ∀ message. ToRawEvent message
onDrop' = createEventMessage "drop"

-- | Handles the `drop` event with an effectful handler that may return `Nothing`
onDrop_ ∷ ∀ message. ToMaybeEvent message
onDrop_ = createRawEvent "drop"

-- | Raises the given message when the `error` event fires
onError ∷ ∀ message. ToEvent message
onError = createEvent "error"

-- | Raises a message built from the `error` event
onError' ∷ ∀ message. ToRawEvent message
onError' = createEventMessage "error"

-- | Handles the `error` event with an effectful handler that may return `Nothing`
onError_ ∷ ∀ message. ToMaybeEvent message
onError_ = createRawEvent "error"