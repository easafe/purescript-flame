-- | Defines helpers for events from outside the view (e.g., custom/window or document events)
-- | For view events, see `Flame.Html.Attribute`
module Flame.Subscription (
      module Exported,
      send,
      onCustomEvent
) where

import Data.Tuple.Nested as DTN
import Effect (Effect)
import Flame.Application.Internal.Dom as FAID
import Flame.Serialization (class UnserializeState)
import Flame.Serialization as FS
import Flame.Subscription.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel') as Exported
import Flame.Subscription.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload') as Exported
import Flame.Types (AppId(..), Source(..), Subscription)
import Foreign as F
import Prelude (class Show, Unit, show, (<<<))
import Web.Event.Event (EventType(..))

-- | Raises an arbitrary message on the given application
send :: forall id message. Show id => AppId id message -> message -> Effect Unit
send (AppId id) = FAID.dispatchCustomEvent (show id)

-- | Subscribe to a `CustomEvent`
-- |
-- | `arg` must be serializable since it might come from external JavaScript
onCustomEvent :: forall arg message. UnserializeState arg => EventType -> (arg -> message) -> Subscription message
onCustomEvent (EventType eventName) message = DTN.tuple3 Custom eventName (message <<< FS.unsafeUnserialize <<< F.unsafeFromForeign)
