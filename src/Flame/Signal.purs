--the idea is that events from outside the view function are expressed as signals
-- such as window or document events (which should be defined here)
-- as user supplied signals
module Flame.Signal (module Exported) where

import Flame.Signal.Signal hiding (ToEventSignal_, ToRawEventSignal_, applyHandler) as Exported
import Flame.Signal.Window hiding (onError_, onError__, onResize_, onResize__, onOffline_, onOffline__, onOnline_, onOnline__, onLoad_, onLoad__, onUnload_, onUnload__) as Exported
import Flame.Signal.Document hiding (onClick_, onClick__, onScroll_, onScroll__, onFocus_, onFocus__, onBlur_, onBlur__, onKeydown_, onKeydown__, onKeypress_, onKeypress__, onKeyup_, onKeyup__, onContextmenu_, onContextmenu__, onDblclick_, onDblclick__, onWheel_, onWheel__, onDrag_, onDrag__, onDragend_, onDragend__, onDragenter_, onDragenter__, onDragstart_, onDragstart__, onDragleave_, onDragleave__, onDragover_, onDragover__, onDrop_, onDrop__
) as Exported



