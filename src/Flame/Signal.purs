--the idea is that events from outside the view function are expressed as signals
-- such as window or document events (which should be defined here)
-- as user supplied signals
module Flame.Signal (module Exported) where

import Flame.Signal.Window as Exported
import Flame.Signal.Global as Exported


