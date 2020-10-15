module Flame.Renderer.Thunk where

import Flame (Key, QuerySelector(..))
import Flame.Types (Html(..))
import Foreign as F
import Prelude (($), (<<<))

-- | A thunk only rerenders if the state parameter changes
-- | https://github.com/snabbdom/snabbdom#thunks
thunk :: forall state message. QuerySelector -> Key -> (state -> Html message) -> state -> Html message
thunk (QuerySelector selector) key fn state = Thunk selector key (fn <<< F.unsafeFromForeign) $ F.unsafeToForeign state