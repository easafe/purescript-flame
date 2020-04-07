-- | The default way to run a Flame application
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
        noChanges
)
where

import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Either (Either(..))
import Data.Either as DET
import Data.Foldable as DF
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Tuple (Tuple(..))
import Debug.Trace (spy)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Class (liftEffect)
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Application.DOM as FAD
import Flame.Application.PreMount as FAP
import Flame.Renderer as FR
import Flame.Types (App, DOMElement, (:>))
import Prelude (Unit, bind, discard, identity, map, pure, show, unit, void, ($), (<$>), (<<<), (<>))
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC
import Web.DOM.ParentNode (QuerySelector(..))

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
        view :: (model -> model) -> Aff Unit
}

noChanges :: forall model. Aff (model -> model)
noChanges = pure identity

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect (Channel (Maybe message))
resumeMount (QuerySelector selector) application = do
        initialModel <- FAP.serializedState selector
        maybeElement <- FAD.querySelector selector
        case maybeElement of
                Just el -> run el true {
                        init: initialModel :> application.init,
                        view: application.view,
                        update: application.update
                }
                Nothing -> EE.throw $ "Error resuming application mount: no element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector which was rendered server-side, discarding the message Channel
resumeMount_ :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect Unit
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

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run :: forall model message. DOMElement -> Boolean -> Application model message -> Effect (Channel (Maybe message))
run el isResumed application = do
        let Tuple initialModel initialMessage = application.init
        state <- ER.new {
                model: initialModel,
                vNode: FR.emptyVNode
        }

        let     --the function which actually run events
                runUpdate message = do
                        { model } <- ER.read state
                        EA.runAff_ (DET.either (EC.log <<< EE.message) render) $ application.update { view: renderFromUpdate, model, message }

                --the function which renders to the dom
                render recordUpdate = do
                        { vNode, model } <- ER.read state
                        let updatedModel = recordUpdate model
                        updatedVNode <- FR.render vNode runUpdate $ application.view updatedModel
                        ER.write {
                                model: updatedModel,
                                vNode: updatedVNode
                        } state

                --the function used to arbitraly render the view from inside Environment.update
                renderFromUpdate recordUpdate = liftEffect $ render recordUpdate

        initialVNode <-
                if isResumed then
                        FR.renderInitialFrom el runUpdate $ application.view initialModel
                else
                        FR.renderInitial el runUpdate $ application.view initialModel
        ER.modify_ (_ { vNode = initialVNode }) state

        case initialMessage of
                Nothing -> pure unit
                Just message -> runUpdate message

        --signals are used for some dom events as well user supplied custom events
        channel <- SC.channel Nothing
        S.runSignal <<< map (DF.traverse_ runUpdate) <<< S.filter DM.isJust Nothing $ SC.subscribe channel
        pure channel