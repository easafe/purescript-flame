-- | Run a flame application with unbounded side effects
-- |
-- | The update function carries context information and runs on `Aff`
module Flame.Application.Effectful(
      Application,
      mount,
      mount_,
      AffUpdate,
      Environment,
      ResumedApplication,
      resumeMount,
      resumeMount_,
      noChanges,
      class Diff,
      diff',
      diff
)
where

import Data.Either as DET
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
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
import Flame.Application.PreMount (class UnserializeModel)
import Flame.Application.PreMount as FAP
import Flame.Renderer.Internal.Dom as FRD
import Flame.Types (App, DomNode, DomRenderingState, (:>))
import Prelude (class Functor, Unit, bind, discard, flip, identity, map, pure, show, unit, void, ($), (<<<), (<>))
import Prim.Row (class Union, class Nub)
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC
import Unsafe.Coerce as UC
import Web.DOM.ParentNode (QuerySelector(..))

foreign import unsafeMergeFields :: forall model subset. Record model -> Record subset -> Record model

type AffUpdate model message = Environment model message -> Aff (model -> model)

-- | `Application` contains
-- | * `init` – the initial model and an optional message to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
      init :: Tuple model (Maybe message),
      update :: AffUpdate model message
)

-- | `ResumedApplication` contains
-- | * `init` – initial list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type ResumedApplication model message = App model message (
      init :: Maybe message,
      update :: AffUpdate model message
)

-- | `Environment` contains context information for `Application.update`
-- | * `model` – the current model
-- | * `message` – the current message
-- | * `view` – forcefully update view with given model changes
type Environment model message = {
      model :: model,
      message :: message,
      display :: (model -> model) -> Aff Unit
}

noChanges :: forall model. Aff (model -> model)
noChanges = pure identity

-- | Convenience type class to update only the given fields of a model
class Diff changed model where
      diff' :: changed -> (model -> model)

instance recordDiff :: (Union changed t model, Nub changed c) => Diff (Record changed) (Record model) where
      diff' changed = \model -> unsafeMergeFields model changed
else
instance functorRecordDiff :: (Functor f, Union changed t model, Nub changed c) => Diff (Record changed) (f (Record model)) where
      diff' changed = map (flip unsafeMergeFields changed)
else
instance newtypeRecordDiff :: (Newtype newtypeModel (Record model), Union changed t model, Nub changed c) => Diff (Record changed) newtypeModel where
      diff' changed = \model -> DN.wrap $ unsafeMergeFields (DN.unwrap model) changed

-- | Wraps diff' in Aff
diff :: forall changed model. Diff changed model => changed -> Aff (model -> model)
diff = pure <<< diff'

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount :: forall model message. UnserializeModel model => QuerySelector -> ResumedApplication model message -> Effect (Channel (Maybe message))
resumeMount (QuerySelector selector) application = do
      initialModel <- FAP.serializedState selector
      maybeElement <- FAD.querySelector selector
      case maybeElement of
            Just element -> run element true {
                  init: initialModel :> application.init,
                  view: application.view,
                  update: application.update
            }
            Nothing -> EE.throw $ "Error resuming application mount: no element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector which was rendered server-side, discarding the message Channel
resumeMount_ :: forall model message. UnserializeModel model => QuerySelector -> ResumedApplication model message -> Effect Unit
resumeMount_ selector application = void $ resumeMount selector application

-- | Mount a Flame application on the given selector
mount :: forall model message. QuerySelector -> Application model message -> Effect (Channel (Maybe message))
mount (QuerySelector selector) application = do
      maybeElement <- FAD.querySelector selector
      case maybeElement of
            Just el -> run el false application
            Nothing -> EE.throw $ "Error mounting application: no element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit
mount_ selector application = void $ mount selector application

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.Internal.Dom.render` for every update
run :: forall model message. DomNode -> Boolean -> Application model message -> Effect (Channel (Maybe message))
run parent isResumed application = do
      let Tuple initialModel initialMessage = application.init
      modelState <- ER.new initialModel
      renderingState <- ER.new (UC.unsafeCoerce 21 :: DomRenderingState)

      let     --the function which actually run events
            runUpdate message = do
                  model <- ER.read modelState
                  EA.runAff_ (DET.either (EC.log <<< EE.message) render) $ application.update { display: renderFromUpdate, model, message }

            --the function which renders to the dom
            render recordUpdate = do
                  model <- ER.read modelState
                  rendering <- ER.read renderingState
                  let updatedModel = recordUpdate model
                  FRD.resume rendering $ application.view updatedModel
                  ER.write updatedModel modelState

            --the function used to arbitraly render the view from inside Environment.update
            renderFromUpdate recordUpdate = liftEffect $ render recordUpdate

      rendering <-
            if isResumed then
                  FRD.startFrom parent runUpdate $ application.view initialModel
            else
                  FRD.start parent runUpdate $ application.view initialModel
      ER.write rendering renderingState

      case initialMessage of
            Nothing -> pure unit
            Just message -> runUpdate message

      --signals are used for some dom events as well user supplied custom events
      channel <- SC.channel Nothing
      S.runSignal <<< map (DF.traverse_ runUpdate) <<< S.filter DM.isJust Nothing $ SC.subscribe channel
      pure channel