-- | Renders changes to the DOM
module Flame.Renderer.Internal.Dom(
      start,
      startFrom,
      resume
) where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn2, EffectFn4)
import Effect.Uncurried as EU
import Flame.Types (DomNode, DomRenderingState, Html)
import Prelude (Unit, pure, unit)

-- | Events that are messages rather than callbacks need to be wrapped from the FFI
type MessageWrapper message = message -> Maybe message

foreign import start_ :: forall message. EffectFn4 (MessageWrapper message) DomNode (Maybe message -> Effect Unit) (Html message) DomRenderingState
foreign import startFrom_ :: forall message. EffectFn4 (MessageWrapper message) DomNode (Maybe message -> Effect Unit) (Html message) DomRenderingState
foreign import resume_ :: forall message. EffectFn2 DomRenderingState (Html message) Unit

-- | Mounts the application on a DOM node
-- |
-- | The node will be set as the parent and otherwise unmodified
start :: forall message. DomNode -> (message -> Effect Unit) -> Html message -> Effect DomRenderingState
start parent updater = EU.runEffectFn4 start_ Just parent (maybeUpdater updater)

-- | Hydrates a server side rendered application
startFrom :: forall message. DomNode -> (message -> Effect Unit) -> Html message -> Effect DomRenderingState
startFrom parent updater = EU.runEffectFn4 startFrom_ Just parent (maybeUpdater updater)

maybeUpdater :: forall message. (message -> Effect Unit) -> (Maybe message -> Effect Unit)
maybeUpdater updater = case _ of
      Just message -> updater message
      _ -> pure unit

-- | Patches the application
resume :: forall message. DomRenderingState -> Html message -> Effect Unit
resume = EU.runEffectFn2 resume_
