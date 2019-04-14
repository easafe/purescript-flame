module Flame.Renderer.String (render) where

import Prelude (Unit, const, pure, (<<<))

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Flame.Types (Element, VNode)
import Flame.Renderer as R

foreign import render_ :: EffectFn1 VNode String

-- | Render markup into a string, useful for server side rendering
render :: Element Unit -> Effect String
render = runEffectFn1 render_ <<< R.toVNodeProxy (const <<< pure)