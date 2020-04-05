-- | The Elm like way to run a Flame application
-- |
-- | The update function returns an array of side effects
module Flame.Application.EffectList(
        Application,
        mount,
        mount_,
        ResumedApplication,
        resumeMount,
        resumeMount_
)
where

import Flame.Types
import Prelude

import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Argonaut.Encode.Generic.Rep (class EncodeRep)
import Data.Argonaut.Encode.Generic.Rep as EGR
import Data.Array ((:))
import Data.Array as DA
import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Application.DOM as FAD
import Flame.Application.PreMount as FAP
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer as FR
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC
import Web.DOM.ParentNode (QuerySelector(..))

-- | `Application` contains
-- | * `init` – the initial model and a list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
        init :: Tuple model (Array (Aff (Maybe message))),
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
)

-- | `ResumedApplication` contains
-- | * `init` – initial list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type ResumedApplication model message = App model message (
        init :: Array (Aff (Maybe message)),
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
)

-- | Mount a Flame application on the given selector which was rendered server-side
resumeMount :: forall model m message. Generic model m => DecodeRep m => QuerySelector -> ResumedApplication model message -> Effect (Channel (Array message))
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
mount :: forall model message. QuerySelector -> Application model message -> Effect (Channel (Array message))
mount (QuerySelector selector) application = do
        maybeElement <- FAD.querySelector selector
        case maybeElement of
                Just el -> run el false application
                Nothing -> EE.throw $ "Error mounting application: no element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. QuerySelector -> Application model message -> Effect Unit
mount_ selector application = void $ mount selector application

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run :: forall model message. DOMElement -> Boolean -> Application model message -> Effect (Channel (Array message))
run el isResumed application = do
        let Tuple initialModel initialAffs = application.init
        state <- ER.new {
                model: initialModel,
                vNode: FR.emptyVNode
        }

        let     --the function which actually run events
                runUpdate message = do
                        st <- ER.read state
                        let Tuple model affs = application.update st.model message
                        render model
                        runMessages affs

                runMessages affs =
                        DF.for_ affs $ EA.runAff_ (case _ of
                                               Left error -> EC.log $ EE.message error --shouldn't stay like this
                                               Right (Just message) -> runUpdate message
                                               _ -> pure unit)

                --the function which renders to the dom
                render model = do
                        currentVNode <- _.vNode <$> ER.read state
                        updatedVNode <- FR.render currentVNode runUpdate $ application.view model
                        ER.write {
                                vNode: updatedVNode,
                                model
                        } state

        initialVNode <-
                if isResumed then
                        FR.renderInitialFrom el runUpdate $ application.view initialModel
                 else
                        FR.renderInitial el runUpdate $ application.view initialModel
        ER.modify_ (_ { vNode = initialVNode }) state

        runMessages initialAffs

        --signals are used for some dom events as well user supplied custom events
        channel <- SC.channel []
        S.runSignal <<< map (DF.traverse_ runUpdate) $ SC.subscribe channel
        pure channel