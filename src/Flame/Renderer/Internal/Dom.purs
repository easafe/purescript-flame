-- | Renders changes to the DOM
module Flame.Renderer.Internal.Dom
      ( start
      , startFrom
      , resume
      , DomRenderingState
      ) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn4)
import Effect.Uncurried as EU
import Flame.Types (DomNode, Html)
import Prelude (Unit, pure, unit)
import Renderer.Internal.Types (MessageWrapper)

-- | FFI class that keeps track of DOM rendering
foreign import data DomRenderingState ∷ Type

foreign import start_ ∷ ∀ message. EffectFn4 (MessageWrapper message) DomNode (Maybe message → Effect Unit) (Html message) DomRenderingState
foreign import startFrom_ ∷ ∀ message. EffectFn4 (MessageWrapper message) DomNode (Maybe message → Effect Unit) (Html message) DomRenderingState
foreign import resume_ ∷ ∀ message. EffectFn2 DomRenderingState (Html message) Unit

-- | Mounts the application on a DOM node
-- |
-- | The node will be set as the parent and otherwise unmodified
start ∷ ∀ message. DomNode → (message → Effect Unit) → Html message → Effect DomRenderingState
start parent updater = EU.runEffectFn4 start_ Just parent (maybeUpdater updater)

-- | Hydrates a server-side rendered application
startFrom ∷ ∀ message. DomNode → (message → Effect Unit) → Html message → Effect DomRenderingState
startFrom parent updater = EU.runEffectFn4 startFrom_ Just parent (maybeUpdater updater)

maybeUpdater ∷ ∀ message. (message → Effect Unit) → (Maybe message → Effect Unit)
maybeUpdater updater = case _ of
      Just message → updater message
      _ → pure unit

-- | Patches the application
resume ∷ ∀ message. DomRenderingState → Html message → Effect Unit
resume = EU.runEffectFn2 resume_
