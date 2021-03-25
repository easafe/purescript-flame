module Flame.Renderer.String (render) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as EU
import Flame.Types (Html)

foreign import render_ :: forall message. EffectFn1 (Html message) String

-- | Render markup into a string, useful for server-side rendering
render :: forall message. Html message -> Effect String
render = EU.runEffectFn1 render_