module Flame.Internal.Equality where

import Prelude (not, ($))

foreign import compareReference ∷ ∀ a. a → a → Boolean

modelHasChanged ∷ ∀ model. model → model → Boolean
modelHasChanged old new = not $ compareReference old new