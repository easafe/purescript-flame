-- | Entry module for a default Flame application
module Flame (module Exported) where

import Flame.Application.EffectList ((:>)) as Exported
import Flame.Application.Effectful as Exported
import Flame.Types (Html) as Exported