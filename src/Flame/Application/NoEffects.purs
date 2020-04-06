-- | Run a Flame application without side effects
-- |
-- | The update function is a pure function from model and message raised
module Flame.Application.NoEffects(
        Application,
        mount,
        mount_,
        ResumedApplication,
        resumeMount,
        resumeMount_
)
where

import Flame.Types (App, (:>))
import Prelude (Unit, bind, pure, unit, ($))

import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Generic.Rep (class Generic)
import Effect (Effect)
import Flame.Application.EffectList as FAE
import Signal.Channel (Channel)
import Web.DOM.ParentNode (QuerySelector)

-- | `Application` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
        init :: model,
        update :: model -> message -> model
)

-- | `ResumedApplication` contains
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type ResumedApplication model message = App model message (
        update :: model -> message -> model
)

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect (Channel (Array message))
resumeMount selector application = FAE.resumeMount selector {
        init: [],
        update: update',
        view: application.view
}
        where   update' model message = application.update model message :> []

-- | Mount a Flame application on the given selector which was rendered server-side, discarding the message Channel
resumeMount_ :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect Unit
resumeMount_ selector application = do
        _ <- resumeMount selector application
        pure unit

-- | Mount a Flame application on the given selector
mount :: forall model message. QuerySelector -> Application model message -> Effect (Channel (Array message))
mount selector application = FAE.mount selector $ application {
        init = application.init :> [],
        update = update'
}
        where update' model message = application.update model message :> []

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit
mount_ selector application = do
        _ <- mount selector application
        pure unit