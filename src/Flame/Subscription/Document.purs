-- | Defines events for the native `document` object
module Flame.Subscription.Document
      ( onClick
      , onClick'
      , onScroll
      , onScroll'
      , onFocus
      , onFocus'
      , onBlur
      , onBlur'
      , onKeydown
      , onKeydown'
      , onKeypress
      , onKeypress'
      , onKeyup
      , onKeyup'
      , onContextmenu
      , onContextmenu'
      , onDblclick
      , onDblclick'
      , onWheel
      , onWheel'
      , onDrag
      , onDrag'
      , onDragend
      , onDragend'
      , onDragenter
      , onDragenter'
      , onDragstart
      , onDragstart'
      , onDragleave
      , onDragleave'
      , onDragover
      , onDragover'
      , onDrop
      , onDrop'
      , onClick_
      , onScroll_
      , onFocus_
      , onBlur_
      , onKeydown_
      , onKeypress_
      , onKeyup_
      , onContextmenu_
      , onDblclick_
      , onWheel_
      , onDrag_
      , onDragend_
      , onDragenter_
      , onDragstart_
      , onDragleave_
      , onDragover_
      , onDrop_
      ) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Flame.Html.Event as FHE
import Flame.Subscription.Internal.Create as FSIC
import Flame.Types (Key, Source(..), Subscription)
import Prelude (map, pure, (<<<))
import Web.Event.Event (Event)

-- | click event fired for the document
onClick ∷ ∀ message. message → Subscription message
onClick = FSIC.createSubscription Document "click"

-- | Raises a message built from the `click` event of `document`
onClick' ∷ ∀ message. (Event → message) → Subscription message
onClick' message = FSIC.createRawSubscription Document "click" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `scroll` event
onScroll ∷ ∀ message. message → Subscription message
onScroll = FSIC.createSubscription Document "scroll"

-- | Raises a message built from the `scroll` event of `document`
onScroll' ∷ ∀ message. (Event → message) → Subscription message
onScroll' message = FSIC.createRawSubscription Document "scroll" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `focus` event
onFocus ∷ ∀ message. message → Subscription message
onFocus = FSIC.createSubscription Document "focus"

-- | Raises a message built from the `focus` event of `document`
onFocus' ∷ ∀ message. (Event → message) → Subscription message
onFocus' message = FSIC.createRawSubscription Document "focus" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `blur` event
onBlur ∷ ∀ message. message → Subscription message
onBlur = FSIC.createSubscription Document "blur"

-- | Raises a message built from the `blur` event of `document`
onBlur' ∷ ∀ message. (Event → message) → Subscription message
onBlur' message = FSIC.createRawSubscription Document "blur" (pure <<< Just <<< message)

-- | Raises a message built from the key pressed when `document` fires the `keydown` event
onKeydown ∷ ∀ message. (Key → message) → Subscription message
onKeydown message = FSIC.createRawSubscription Document "keydown" (map (Just <<< message) <<< FHE.pressedKey)

-- | Raises a message built from the `keydown` event of `document`
onKeydown' ∷ ∀ message. (Event → message) → Subscription message
onKeydown' message = FSIC.createRawSubscription Document "keydown" (pure <<< Just <<< message)

-- | Raises a message built from the key pressed when `document` fires the `keypress` event
onKeypress ∷ ∀ message. (Key → message) → Subscription message
onKeypress message = FSIC.createRawSubscription Document "keypress" (map (Just <<< message) <<< FHE.pressedKey)

-- | Raises a message built from the `keypress` event of `document`
onKeypress' ∷ ∀ message. (Event → message) → Subscription message
onKeypress' message = FSIC.createRawSubscription Document "keypress" (pure <<< Just <<< message)

-- | Raises a message built from the key pressed when `document` fires the `keyup` event
onKeyup ∷ ∀ message. (Key → message) → Subscription message
onKeyup message = FSIC.createRawSubscription Document "keyup" (map (Just <<< message) <<< FHE.pressedKey)

-- | Raises a message built from the `keyup` event of `document`
onKeyup' ∷ ∀ message. (Event → message) → Subscription message
onKeyup' message = FSIC.createRawSubscription Document "keyup" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `contextmenu` event
onContextmenu ∷ ∀ message. message → Subscription message
onContextmenu = FSIC.createSubscription Document "contextmenu"

-- | Raises a message built from the `contextmenu` event of `document`
onContextmenu' ∷ ∀ message. (Event → message) → Subscription message
onContextmenu' message = FSIC.createRawSubscription Document "contextmenu" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dblclick` event
onDblclick ∷ ∀ message. message → Subscription message
onDblclick = FSIC.createSubscription Document "dblclick"

-- | Raises a message built from the `dblclick` event of `document`
onDblclick' ∷ ∀ message. (Event → message) → Subscription message
onDblclick' message = FSIC.createRawSubscription Document "dblclick" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `wheel` event
onWheel ∷ ∀ message. message → Subscription message
onWheel = FSIC.createSubscription Document "wheel"

-- | Raises a message built from the `wheel` event of `document`
onWheel' ∷ ∀ message. (Event → message) → Subscription message
onWheel' message = FSIC.createRawSubscription Document "wheel" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `drag` event
onDrag ∷ ∀ message. message → Subscription message
onDrag = FSIC.createSubscription Document "drag"

-- | Raises a message built from the `drag` event of `document`
onDrag' ∷ ∀ message. (Event → message) → Subscription message
onDrag' message = FSIC.createRawSubscription Document "drag" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dragend` event
onDragend ∷ ∀ message. message → Subscription message
onDragend = FSIC.createSubscription Document "dragend"

-- | Raises a message built from the `dragend` event of `document`
onDragend' ∷ ∀ message. (Event → message) → Subscription message
onDragend' message = FSIC.createRawSubscription Document "dragend" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dragenter` event
onDragenter ∷ ∀ message. message → Subscription message
onDragenter = FSIC.createSubscription Document "dragenter"

-- | Raises a message built from the `dragenter` event of `document`
onDragenter' ∷ ∀ message. (Event → message) → Subscription message
onDragenter' message = FSIC.createRawSubscription Document "dragenter" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dragstart` event
onDragstart ∷ ∀ message. message → Subscription message
onDragstart = FSIC.createSubscription Document "dragstart"

-- | Raises a message built from the `dragstart` event of `document`
onDragstart' ∷ ∀ message. (Event → message) → Subscription message
onDragstart' message = FSIC.createRawSubscription Document "dragstart" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dragleave` event
onDragleave ∷ ∀ message. message → Subscription message
onDragleave = FSIC.createSubscription Document "dragleave"

-- | Raises a message built from the `dragleave` event of `document`
onDragleave' ∷ ∀ message. (Event → message) → Subscription message
onDragleave' message = FSIC.createRawSubscription Document "dragleave" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `dragover` event
onDragover ∷ ∀ message. message → Subscription message
onDragover = FSIC.createSubscription Document "dragover"

-- | Raises a message built from the `dragover` event of `document`
onDragover' ∷ ∀ message. (Event → message) → Subscription message
onDragover' message = FSIC.createRawSubscription Document "dragover" (pure <<< Just <<< message)

-- | Raises the given message when `document` fires the `drop` event
onDrop ∷ ∀ message. message → Subscription message
onDrop = FSIC.createSubscription Document "drop"

-- | Raises a message built from the `drop` event of `document`
onDrop' ∷ ∀ message. (Event → message) → Subscription message
onDrop' message = FSIC.createRawSubscription Document "drop" (pure <<< Just <<< message)

-- | Handles the `click` event of `document` with an effectful handler that may return `Nothing`
onClick_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onClick_ = FSIC.createRawSubscription Document "click"

-- | Handles the `scroll` event of `document` with an effectful handler that may return `Nothing`
onScroll_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onScroll_ = FSIC.createRawSubscription Document "scroll"

-- | Handles the `focus` event of `document` with an effectful handler that may return `Nothing`
onFocus_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onFocus_ = FSIC.createRawSubscription Document "focus"

-- | Handles the `blur` event of `document` with an effectful handler that may return `Nothing`
onBlur_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onBlur_ = FSIC.createRawSubscription Document "blur"

-- | Handles the `keydown` event of `document` with an effectful handler that may return `Nothing`
onKeydown_ ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeydown_ = FSIC.createRawSubscription Document "keydown"

-- | Handles the `keypress` event of `document` with an effectful handler that may return `Nothing`
onKeypress_ ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeypress_ = FSIC.createRawSubscription Document "keypress"

-- | Handles the `keyup` event of `document` with an effectful handler that may return `Nothing`
onKeyup_ ∷ ∀ message. (Key → Effect (Maybe message)) → Subscription message
onKeyup_ = FSIC.createRawSubscription Document "keyup"

-- | Handles the `contextmenu` event of `document` with an effectful handler that may return `Nothing`
onContextmenu_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onContextmenu_ = FSIC.createRawSubscription Document "contextmenu"

-- | Handles the `dblclick` event of `document` with an effectful handler that may return `Nothing`
onDblclick_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDblclick_ = FSIC.createRawSubscription Document "dblclick"

-- | Handles the `wheel` event of `document` with an effectful handler that may return `Nothing`
onWheel_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onWheel_ = FSIC.createRawSubscription Document "wheel"

-- | Handles the `drag` event of `document` with an effectful handler that may return `Nothing`
onDrag_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDrag_ = FSIC.createRawSubscription Document "drag"

-- | Handles the `dragend` event of `document` with an effectful handler that may return `Nothing`
onDragend_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragend_ = FSIC.createRawSubscription Document "dragend"

-- | Handles the `dragenter` event of `document` with an effectful handler that may return `Nothing`
onDragenter_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragenter_ = FSIC.createRawSubscription Document "dragenter"

-- | Handles the `dragstart` event of `document` with an effectful handler that may return `Nothing`
onDragstart_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragstart_ = FSIC.createRawSubscription Document "dragstart"

-- | Handles the `dragleave` event of `document` with an effectful handler that may return `Nothing`
onDragleave_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragleave_ = FSIC.createRawSubscription Document "dragleave"

-- | Handles the `dragover` event of `document` with an effectful handler that may return `Nothing`
onDragover_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDragover_ = FSIC.createRawSubscription Document "dragover"

-- | Handles the `drop` event of `document` with an effectful handler that may return `Nothing`
onDrop_ ∷ ∀ message. (Event → Effect (Maybe message)) → Subscription message
onDrop_ = FSIC.createRawSubscription Document "drop"