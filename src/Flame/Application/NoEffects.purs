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

import Effect (Effect)
import Flame.Application.EffectList as FAE
import Flame.Serialization (class UnserializeState)
import Flame.Types (App, AppId, (:>))
import Prelude (class Show, Unit, ($), (<<<))

import Web.DOM.ParentNode (QuerySelector)

-- | `Application` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type Application model message = App model message (
      init :: model,
      update :: model -> message -> model
)

-- | `ResumedApplication` contains
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type ResumedApplication model message = App model message (
      update :: model -> message -> model
)

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount_ :: forall model message. UnserializeState model => QuerySelector -> ResumedApplication model message -> Effect Unit
resumeMount_ selector = FAE.resumeMount_ selector <<< toResumedApplication

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMount :: forall id model message. UnserializeState model => Show id => QuerySelector -> AppId id message -> ResumedApplication model message -> Effect Unit
resumeMount selector appId = FAE.resumeMount selector appId <<< toResumedApplication

toResumedApplication :: forall model message. ResumedApplication model message -> FAE.ResumedApplication model message
toResumedApplication { update, view, subscribe } = {
      init: [],
      update: \model message -> update model message :> [],
      view,
      subscribe
}

-- | Mount a Flame application that can be fed arbitrary external messages
mount :: forall id model message. Show id => QuerySelector -> AppId id message -> Application model message -> Effect Unit
mount selector appId application = FAE.mount selector appId $ application {
      init = application.init :> [],
      update = \model message -> application.update model message :> []
}

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit
mount_ selector application = FAE.mount_ selector $ application {
      init = application.init :> [],
      update = \model message -> application.update model message :> []
}