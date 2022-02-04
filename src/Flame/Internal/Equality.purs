module Flame.Internal.Equality where

import Prelude (not, ($))

foreign import compareReference_ :: forall a. a -> a -> Boolean

compareReference :: forall a. a -> a -> Boolean
compareReference a a2 = compareReference_ a a2

modelHasChanged :: forall model. model -> model -> Boolean
modelHasChanged old new = not $ compareReference old new