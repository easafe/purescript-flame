-- | Convenience module to simplify export list
module Flame.HTML.Attribute(module Exported) where

import Flame.HTML.Attribute.Internal hiding (caseify) as Exported
import Flame.HTML.Event hiding (key, nodeValue, checkedValue, preventDefault) as Exported
import Flame.HTML.Property as Exported