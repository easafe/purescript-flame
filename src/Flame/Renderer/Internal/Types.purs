module Renderer.Internal.Types where

import Data.Maybe (Maybe)

-- | Events that are messages rather than callbacks need to be wrapped from the FFI
type MessageWrapper message = message → Maybe message