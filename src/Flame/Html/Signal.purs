-- | Defines helpers for custom events that are send to the application message Channel
-- | For view events, view `Flame.Html.Attribute`
module Flame.Html.Signal (module Exported) where

import Flame.Html.Signal.Source (createEventSource, createRawEventSource, createSpecialEventSource, send) as Exported
import Flame.Html.Signal.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload') as Exported
import Flame.Html.Signal.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel') as Exported



