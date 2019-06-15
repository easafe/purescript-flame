-- | Run a Flame application without side effects
-- |
-- | The update function is a pure function from model and message raised
module Flame.Application.NoEffects(
        Application,
        emptyApp,
        mount,
        mount_
)
where

import Effect (Effect)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Element as FHE
import Flame.Types (App)
import Prelude (Unit, const, unit, ($), (<<<), bind, pure)
import Signal.Channel (Channel)

-- | `Application` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
        init :: model,
        update :: model -> message -> model
)

-- | A bare bones application
emptyApp :: Application Unit Unit
emptyApp = {
        init: unit,
        update: const <<< const unit,
        view: const (FHE.createEmptyElement "bs")
}

-- | Mount a Flame application in the given selector
mount :: forall model message. String -> Application model message -> Effect (Channel (Array message))
mount selector application = FAE.mount selector $ application { init = application.init :> [], update = update' }
        where update' model message = application.update model message :> []

-- | Mount a Flame application in the given selector, discarding the message Channel
mount_ :: forall model message. String -> Application model message -> Effect Unit
mount_ selector application = do
        _ <- mount selector application
        pure unit