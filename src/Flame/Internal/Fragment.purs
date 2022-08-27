module Flame.Internal.Fragment where

foreign import createFragmentNode :: forall html message. Array (html message) -> html message