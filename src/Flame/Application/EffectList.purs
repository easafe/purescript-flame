-- | The Elm like way to run a Flame application
-- |
-- | The update function returns an array of side effects
module Flame.Application.EffectList(
      ListUpdate,
      Application,
      noMessages,
      mount,
      mount_,
      ResumedApplication,
      resumeMount,
      resumeMount_
)
where

import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (class GenericShow)
import Data.Generic.Rep.Show as DGRS
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Application.Internal.Dom as FAD
import Flame.Application.Internal.PreMount as FAP
import Flame.Internal.Equality as FIE
import Flame.Renderer.Internal.Dom as FRD
import Flame.Serialization (class UnserializeState)
import Flame.Subscription.Internal.Listener as FSIL
import Flame.Types (App, AppId(..), ApplicationId, DomNode, DomRenderingState, (:>))
import Prelude (class Show, Unit, bind, discard, map, pure, show, unit, void, when, ($), (<<<), (<>))
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC
import Unsafe.Coerce as UC
import Web.DOM.ParentNode (QuerySelector(..))

type ListUpdate model message = model -> message -> Tuple model (Array (Aff (Maybe message)))

-- | `Application` contains
-- | * `init` – the initial model and a list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
      init :: Tuple model (Array (Aff (Maybe message))),
      update :: ListUpdate model message
)

-- | `ResumedApplication` contains
-- | * `init` – initial list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type ResumedApplication model message = App model message (
      init :: Array (Aff (Maybe message)),
      update :: ListUpdate model message
)

noMessages :: forall model message. model -> Tuple model (Array (Aff (Maybe message)))
noMessages model = model :> []

noAppId :: forall message. Maybe (AppId Unit message)
noAppId = Nothing

showId :: forall id message. Show id => (AppId id message) -> String
showId (AppId id) = show id

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount_ :: forall model message. UnserializeState model => QuerySelector -> ResumedApplication model message -> Effect Unit
resumeMount_ selector = resumeMountWith selector noAppId

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMount :: forall id model message. UnserializeState model => Show id => QuerySelector -> AppId id message -> ResumedApplication model message -> Effect Unit
resumeMount selector appId = resumeMountWith selector (Just appId)

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMountWith :: forall id model message. UnserializeState model => Show id => QuerySelector -> Maybe (AppId id message) -> ResumedApplication model message -> Effect Unit
resumeMountWith (QuerySelector selector) appId { update, view, init, subscribe } = do
      initialModel <- FAP.serializedState selector
      maybeElement <- FAD.querySelector selector
      case maybeElement of
            Just parent -> run parent true (map showId appId) {
                  init: initialModel :> init,
                  view,
                  update,
                  subscribe
            }
            Nothing -> EE.throw $ "Error resuming application mount: no element matching selector " <> selector <> " found!"

-- | Mount a Flame application on the given selector
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit
mount_ selector = mountWith selector noAppId

-- | Mount a Flame application that can be fed arbitrary external messages
mount :: forall id model message. Show id => QuerySelector -> AppId id message -> Application model message -> Effect Unit
mount selector appId = mountWith selector (Just appId)

mountWith :: forall id model message. Show id => QuerySelector -> Maybe (AppId id message) -> Application model message -> Effect Unit
mountWith (QuerySelector selector) appId application = do
      maybeElement <- FAD.querySelector selector
      case maybeElement of
            Just parent -> run parent false (map showId appId) application
            Nothing -> EE.throw $ "Error mounting application"

-- | Keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run :: forall model message. DomNode -> Boolean -> Maybe ApplicationId -> Application model message -> Effect Unit
run parent isResumed appId { update, view, init: Tuple initialModel initialAffs, subscribe } = do
      modelState <- ER.new initialModel
      renderingState <- ER.new (UC.unsafeCoerce 21 :: DomRenderingState)

      let   --the function which actually run events
            runUpdate message = do
                  currentModel <- ER.read modelState
                  let Tuple model affs = update currentModel message
                  when (FIE.modelHasChanged currentModel model) $ render model
                  runMessages affs

            runMessages affs =
                  DF.for_ affs $ EA.runAff_
                        (case _ of
                              Left error -> EC.log $ EE.message error
                              Right (Just message) -> runUpdate message
                              _ -> pure unit)

            --the function which renders to the dom
            render model = do
                  rendering <- ER.read renderingState
                  FRD.resume rendering $ view model
                  ER.write model modelState

      rendering <-
            if isResumed then
                  FRD.startFrom parent runUpdate $ view initialModel
             else
                  FRD.start parent runUpdate $ view initialModel
      ER.write rendering renderingState

      runMessages initialAffs

      --subscriptions are used for external events
      case appId of
            Nothing -> pure unit
            Just id -> FSIL.createMessageListener id runUpdate
      DF.traverse_ (FSIL.createSubscription runUpdate) subscribe