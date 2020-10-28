module Flame.Renderer.Key where

import Flame.Html.Attribute (ToStringAttribute)
import Flame.Types (NodeData)

foreign import createKey :: forall message. String -> NodeData message

-- | Set the key attribute for "keyed" rendering
key :: ToStringAttribute
key = createKey