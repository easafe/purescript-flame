-- | Convenience module to simplify export list
module Flame.HTML.Attribute(module Exported) where

import Flame.HTML.Attribute.Internal hiding (caseify, booleanToFalsyString) as Exported
import Flame.HTML.Event hiding (key, nodeValue, checkedValue, keyInput, preventDefault) as Exported