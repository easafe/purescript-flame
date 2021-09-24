-- | Render application with React Native
module Flame.Renderer.Internal.Native (start, NativeRenderingState) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn4)
import Effect.Uncurried as EU
import Flame.Types (Html)
import Renderer.Internal.Types (MessageWrapper)

type Name = String

foreign import start_ ∷ ∀ message. EffectFn4 (MessageWrapper message) (Maybe message → Effect Unit) Name (Html message) NativeRenderingState

-- | FFI class that keeps track of DOM rendering
foreign import data NativeRenderingState ∷ Type

start ∷ ∀ message. (message → Effect Unit) → Name -> Html message → Effect NativeRenderingState
start updater name = EU.runEffectFn4 start_ Just (maybeUpdater updater) name

maybeUpdater ∷ ∀ message. (message → Effect Unit) → (Maybe message → Effect Unit)
maybeUpdater updater = case _ of
      Just message → updater message
      _ → pure unit