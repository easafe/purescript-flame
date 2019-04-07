module Flame.Renderer.String (render) where

import Prelude

import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Flame.Type
import Flame.Renderer as R

foreign import render_ :: EffectFn1 VNodeProxy String

render :: Element Unit -> Effect String
render = runEffectFn1 render_ <<< R.toVNodeProxy pure