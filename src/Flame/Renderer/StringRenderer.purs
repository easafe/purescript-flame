module Flame.Renderer.String (render) where

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Flame.Renderer as R
import Flame.Types (Html, VNode)
import Prelude

foreign import render_ :: EffectFn1 VNode String

-- | Render markup into a string, useful for server side rendering of static pages
render :: forall a. Html a -> Effect String
render = runEffectFn1 render_ <<< R.toVNodeProxy (\_ _ -> pure unit)