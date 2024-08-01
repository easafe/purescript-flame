-- | Renders application with react native
module Flame.Renderer.Internal.Native (NativeApp, start, resume) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn3, EffectFn5)
import Effect.Uncurried as EU
import Flame.Types (Html)
import Debug

-- | Events that are messages rather than callbacks need to be wrapped from the FFI
type MessageWrapper message = message → Maybe message

foreign import data NativeApp ∷ Type

foreign import start_ ∷ ∀ message model. EffectFn5 (MessageWrapper message) (Maybe message → Effect Unit) String (Html message) model NativeApp

foreign import resume_ ∷ ∀ message model. EffectFn3 NativeApp (model → Html message) model Unit

start ∷ ∀ message model. (message → Effect Unit) → String → Html message → model → Effect NativeApp
start updater = EU.runEffectFn5 start_ Just (maybeUpdater updater)

resume ∷ ∀ message model. NativeApp → (model → Html message) → model → Effect Unit
resume = EU.runEffectFn3 resume_

maybeUpdater ∷ ∀ message. (message → Effect Unit) → (Maybe message → Effect Unit)
maybeUpdater updater = case _ of
      Just message → updater message
      _ → pure unit