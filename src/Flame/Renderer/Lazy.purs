module Flame.Renderer.Lazy where

import Data.Array as DA
import Data.Maybe (Maybe)
import Data.Maybe as DM
import Flame.Types (Html, Key)

foreign import createLazyNode :: forall message arg. Array String -> (arg -> Html message) -> arg -> Html message

-- | Creates a lazy node
-- |
-- | Lazy nodes are only updated if the `arg` parameter changes (compared by reference)
lazy :: forall arg message.  Maybe Key -> (arg -> Html message) -> arg -> Html message
lazy maybeKey render arg = createLazyNode (DM.maybe [] DA.singleton maybeKey) render arg
