-- | Run a flame application with unbounded side effects
-- |
-- | The update function carries context information and runs on `Aff`
module Flame.Application.Effectful
      ( Application
      , mount
      , mount_
      , AffUpdate
      , Environment
      , ResumedApplication
      , resumeMount
      , resumeMount_
      , noChanges
      , class Diff
      , diff'
      , diff
      ) where

import Data.Either as DET
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Newtype (class Newtype)
import Data.Newtype as DN
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Class (liftEffect)
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Application.Internal.Dom as FAD
import Flame.Application.Internal.PreMount as FAP
import Flame.Renderer.Internal.Dom (DomRenderingState)
import Flame.Renderer.Internal.Dom as FRD
import Flame.Serialization (class UnserializeState)
import Flame.Subscription.Internal.Listener as FSIL
import Flame.Types (App, AppId(..), ApplicationId, DomNode, (:>))
import Prelude (class Functor, class Show, Unit, bind, discard, flip, identity, map, pure, show, unit, ($), (<<<), (<>))
import Prim.Row (class Union, class Nub)
import Unsafe.Coerce as UC
import Web.DOM.ParentNode (QuerySelector(..))

foreign import unsafeMergeFields ∷ ∀ model subset. Record model → Record subset → Record model

type AffUpdate model message = Environment model message → Aff (model → model)

-- | `Application` contains
-- | * `init` – the initial model and an optional message to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type Application model message = App model message
      ( init ∷ Tuple model (Maybe message)
      , update ∷ AffUpdate model message
      )

-- | `ResumedApplication` contains
-- | * `init` – initial list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type ResumedApplication model message = App model message
      ( init ∷ Maybe message
      , update ∷ AffUpdate model message
      )

-- | `Environment` contains context information for `Application.update`
-- | * `model` – the current model
-- | * `message` – the current message
-- | * `view` – forcefully update view with given model changes
type Environment model message =
      { model ∷ model
      , message ∷ message
      , display ∷ (model → model) → Aff Unit
      }

-- | Convenience type class to update only the given fields of a model
class Diff changed model where
      diff' ∷ changed → (model → model)

instance recordDiff ∷ (Union changed t model, Nub changed c) ⇒ Diff (Record changed) (Record model) where
      diff' changed = \model → unsafeMergeFields model changed
else instance functorRecordDiff ∷ (Functor f, Union changed t model, Nub changed c) ⇒ Diff (Record changed) (f (Record model)) where
      diff' changed = map (flip unsafeMergeFields changed)
else instance newtypeRecordDiff ∷ (Newtype newtypeModel (Record model), Union changed t model, Nub changed c) ⇒ Diff (Record changed) newtypeModel where
      diff' changed = \model → DN.wrap $ unsafeMergeFields (DN.unwrap model) changed

-- | Wraps diff' in Aff
diff ∷ ∀ changed model. Diff changed model ⇒ changed → Aff (model → model)
diff = pure <<< diff'

noChanges ∷ ∀ model. Aff (model → model)
noChanges = pure identity

noAppId ∷ ∀ message. Maybe (AppId Unit message)
noAppId = Nothing

showId ∷ ∀ id message. Show id ⇒ (AppId id message) → String
showId (AppId id) = show id

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount_ ∷ ∀ model message. UnserializeState model ⇒ QuerySelector → ResumedApplication model message → Effect Unit
resumeMount_ selector = resumeMountWith selector noAppId

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMount ∷ ∀ id model message. UnserializeState model ⇒ Show id ⇒ QuerySelector → AppId id message → ResumedApplication model message → Effect Unit
resumeMount selector appId = resumeMountWith selector (Just appId)

-- | Mount on the given selector a Flame application which was rendered server-side and can be fed arbitrary external messages
resumeMountWith ∷ ∀ id model message. UnserializeState model ⇒ Show id ⇒ QuerySelector → Maybe (AppId id message) → ResumedApplication model message → Effect Unit
resumeMountWith (QuerySelector selector) appId { update, view, init, subscribe } = do
      initialModel ← FAP.serializedState selector
      maybeElement ← FAD.querySelector selector
      case maybeElement of
            Just parent → run parent true (map showId appId)
                  { init: initialModel :> init
                  , view
                  , update
                  , subscribe
                  }
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

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.Internal.Dom.render` for every update
run ∷ ∀ model message. DomNode → Boolean → Maybe ApplicationId → Application model message → Effect Unit
run parent isResumed appId { init: Tuple initialModel initialMessage, update, view, subscribe } = do
      modelState ← ER.new initialModel
      renderingState ← ER.new (UC.unsafeCoerce 21 ∷ DomRenderingState)

      let --the function which actually run events
            runUpdate message = do
                  model ← ER.read modelState
                  EA.runAff_ (DET.either (EC.log <<< EE.message) render) $ update { display: renderFromUpdate, model, message }

            --the function which renders to the dom
            render recordUpdate = do
                  model ← ER.read modelState
                  rendering ← ER.read renderingState
                  let updatedModel = recordUpdate model
                  FRD.resume rendering $ view updatedModel
                  ER.write updatedModel modelState

            --the function used to arbitraly render the view from inside Environment.update
            renderFromUpdate recordUpdate = liftEffect $ render recordUpdate

      rendering ←
            if isResumed then
                  FRD.startFrom parent runUpdate $ view initialModel
            else
                  FRD.start parent runUpdate $ view initialModel
      ER.write rendering renderingState

      case initialMessage of
            Nothing → pure unit
            Just message → runUpdate message

      --subscriptions are used for external events
      case appId of
            Nothing → pure unit
            Just id → FSIL.createMessageListener id runUpdate
      DF.traverse_ (FSIL.createSubscription runUpdate) subscribe