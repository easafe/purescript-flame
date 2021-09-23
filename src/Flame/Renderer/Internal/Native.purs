-- | Render application with React Native
module Flame.Renderer.Internal.Native (start, NativeRenderingState) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn3)
import Effect.Uncurried as EU
import Flame.Types (Html)
import Renderer.Internal.Types (MessageWrapper)

foreign import start_ ∷ ∀ message. EffectFn3 (MessageWrapper message) (Maybe message → Effect Unit) (Html message) NativeRenderingState

-- | FFI class that keeps track of DOM rendering
foreign import data NativeRenderingState ∷ Type

start ∷ ∀ message. (message → Effect Unit) → Html message → Effect NativeRenderingState
start updater = EU.runEffectFn3 start_ Just (maybeUpdater updater)

maybeUpdater ∷ ∀ message. (message → Effect Unit) → (Maybe message → Effect Unit)
maybeUpdater updater = case _ of
      Just message → updater message
      _ → pure unit