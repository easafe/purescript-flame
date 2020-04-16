-- | Defines helpers for custom events that are send to the application message Channel
module Flame.External (module Exported) where

import Flame.External.Source (createEventSource, createRawEventSource, createSpecialEventSource, send) as Exported
import Flame.External.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload') as Exported
import Flame.External.Document (onBlur, onBlur', onClick, onClick', onContextmenu, onContextmenu', onDblclick, onDblclick', onDrag, onDrag', onDragend, onDragend', onDragenter, onDragenter', onDragleave, onDragleave', onDragover, onDragover', onDragstart, onDragstart', onDrop, onDrop', onFocus, onFocus', onKeydown, onKeydown', onKeypress, onKeypress', onKeyup, onKeyup', onScroll, onScroll', onWheel, onWheel') as Exported



