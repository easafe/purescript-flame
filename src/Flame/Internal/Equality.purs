module Flame.Internal.Equality where

import Prelude (not, ($))

-- | JavaScript strict (reference) equality
foreign import compareReference ∷ ∀ a. a → a → Boolean

-- | Whether the model is a different reference; structurally equal models are considered changed
modelHasChanged ∷ ∀ model. model → model → Boolean
modelHasChanged old new = not $ compareReference old new