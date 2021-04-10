module Flame.Internal.Equality where

import Prelude (not, ($))

import Data.Function.Uncurried (Fn2)
import Data.Function.Uncurried as DFU

foreign import compareReference_ :: forall a. Fn2 a a Boolean

compareReference :: forall a. a -> a -> Boolean
compareReference = DFU.runFn2 compareReference_

modelHasChanged :: forall model. model -> model -> Boolean
modelHasChanged old new = not $ compareReference old new