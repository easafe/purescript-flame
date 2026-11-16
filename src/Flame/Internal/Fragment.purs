module Flame.Internal.Fragment where

-- | Creates a fragment virtual node; `html` is abstract to avoid a cyclic import with `Flame.Types`
foreign import createFragmentNode ∷ ∀ html message. Array (html message) → html message