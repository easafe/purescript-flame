module Flame.Internal.Equality where

import Prelude (not, ($))

foreign import compareReference :: forall a. a -> a -> Boolean

modelHasChanged :: forall model. model -> model -> Boolean
modelHasChanged old new = not $ compareReference old new