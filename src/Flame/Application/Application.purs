-- | Run TEA like applications
module Flame.Application
      ( Update
      , App
      , Application
      , noMessages
      , mount
      , mount_
      , ResumedApplication
      , resumeMount
      , resumeMount_
      ) where

import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested ((/\))
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
import Flame.Types (AppId(..), ApplicationId, DomNode, DomRenderingState, Html, Subscription)
import Prelude (class Show, Unit, bind, discard, map, pure, show, unit, when, ($), (<>))
import Unsafe.Coerce as UC
import Web.DOM.ParentNode (QuerySelector(..))

type Update model message = model → message → Tuple model (Array (Aff (Maybe message)))

-- | Abstracts over common fields of an `Application`
type App model message extension =
      { view ∷ model → Html message
      , subscribe ∷ Array (Subscription message)
      | extension
      }

-- | `Application` contains
-- | * `model` – starting model
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type Application model message = App model message
      ( model ∷ model
      , update ∷ Update model message
      )

-- | `ResumedApplication` contains
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type ResumedApplication model message = App model message
      ( update ∷ Update model message
      )

noMessages ∷ ∀ model message. model → Tuple model (Array (Aff (Maybe message)))
noMessages model = model /\ []

noAppId ∷ ∀ message. Maybe (AppId Unit message)
noAppId = Nothing

showId ∷ ∀ id message. Show id ⇒ (AppId id message) → String
showId (AppId id) = show id

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount_ ∷ ∀ model message. UnserializeState model ⇒ QuerySelector → ResumedApplication model message → Effect model
resumeMount_ selector = resumeMountWith selector noAppId

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMount ∷ ∀ id model message. UnserializeState model ⇒ Show id ⇒ QuerySelector → AppId id message → ResumedApplication model message → Effect model
resumeMount selector appId = resumeMountWith selector (Just appId)

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMountWith ∷ ∀ id model message. UnserializeState model ⇒ Show id ⇒ QuerySelector → Maybe (AppId id message) → ResumedApplication model message → Effect model
resumeMountWith (QuerySelector selector) appId resumed = do
      model ← FAP.serializedState selector
      maybeElement ← FAD.querySelector selector
      case maybeElement of
            Just parent → do
                  run parent true (map showId appId)
                        { model
                        , view : resumed.view
                        , update : resumed.update
                        , subscribe :  resumed.subscribe
                  }
                  pure model
            Nothing → EE.throw $ "Error resuming application mount: no element matching selector " <> selector <> " found!"

-- | Mount a Flame application on the given selector
mount_ ∷ ∀ model message. QuerySelector → Application model message → Effect Unit
mount_ selector = mountWith selector noAppId

-- | Mount a Flame application that can be fed arbitrary external messages
mount ∷ ∀ id model message. Show id ⇒ QuerySelector → AppId id message → Application model message → Effect Unit
mount selector appId = mountWith selector (Just appId)

mountWith ∷ ∀ id model message. Show id ⇒ QuerySelector → Maybe (AppId id message) → Application model message → Effect Unit
mountWith (QuerySelector selector) appId application = do
      maybeElement ← FAD.querySelector selector
      case maybeElement of
            Just parent → run parent false (map showId appId) application
            Nothing → EE.throw $ "Error mounting application"

-- | Keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run ∷ ∀ model message. DomNode → Boolean → Maybe ApplicationId → Application model message → Effect Unit
run parent isResumed appId application = do
      modelState ← ER.new application.model
      renderingState ← ER.new (UC.unsafeCoerce 21 ∷ DomRenderingState)

      let --the function which actually run events
            runUpdate message = do
                  currentModel ← ER.read modelState
                  let Tuple model affs = application.update currentModel message
                  when (FIE.modelHasChanged currentModel model) $ render model
                  DF.for_ affs $ EA.runAff_
                        ( case _ of
                                Left error → EC.log $ EE.message error
                                Right (Just msg) → runUpdate msg
                                _ → pure unit
                        )

            --the function which renders to the dom
            render model = do
                  rendering ← ER.read renderingState
                  FRD.resume rendering $ application.view model
                  ER.write model modelState

      rendering ←
            if isResumed then
                  FRD.startFrom parent runUpdate $ application.view application.model
            else
                  FRD.start parent runUpdate $ application.view application.model
      ER.write rendering renderingState

      --subscriptions are used for external events
      case appId of
            Nothing → pure unit
            Just id → FSIL.createMessageListener id runUpdate
      DF.traverse_ (FSIL.createSubscription runUpdate) application.subscribe