-- | Convenience module to simplify export list
module Flame.HTML.Attribute(module Exported) where

import Flame.HTML.Attribute.Internal hiding (caseify) as Exported
import Flame.HTML.Event hiding (nodeValue) as Exported
import Flame.HTML.Property as Exported