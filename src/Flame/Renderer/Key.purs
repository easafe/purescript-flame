module Flame.Renderer.Key where

import Flame.HTML.Attribute (ToStringAttribute)
import Flame.Types(NodeData(..))

-- | Set the key attribute for "keyed" rendering
-- | https://github.com/snabbdom/snabbdom#key--string--number
key :: ToStringAttribute
key = Key