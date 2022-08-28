module Flame.Renderer.String (render) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as EU
import Flame.Types (Html)

foreign import render_ ∷ ∀ message. EffectFn1 (Html message) String

-- | Render markup into a string, useful for server-side rendering
-- |
-- | If the root tag is `html`, doctype is automatically added
render ∷ ∀ message. Html message → Effect String
render = EU.runEffectFn1 render_