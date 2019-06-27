-- | The Elm like way to run a Flame application
-- |
-- | The update function returns an array of side effects
module Flame.Application.EffectList(
        Application,
        emptyApp,
        preMount,
        mount,
        mount_,
        -- resumeMount,
        -- resumeMount_,
        (:>)
)
where

import Flame.Types
import Prelude

import Data.Argonaut.Core as DAC
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
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer as FR
import Flame.Renderer.String as FRS
import Partial.Unsafe (unsafePartial)
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC

-- | `Application` contains
-- | * `init` – the initial model and a list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
        init :: Tuple model (Array (Aff (Maybe message))),
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
)

-- | `ResumedApplication` contains
-- | * `init` – the initial model
-- | * `view` – a function to update your markup
type PreApplication model message = App model message (
        init :: model
)

-- | `ResumedApplication` contains
-- | * `init` – initial list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type ResumedApplication model message = App model message (
        init :: Array (Aff (Maybe message)),
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
)

-- | Infix tuple constructor
infixr 6 Tuple as :>

-- | A bare bones application
emptyApp :: Application Unit Unit
emptyApp = {
        init: unit :> [],
        update,
        view: const (HE.createEmptyElement "bs")
}
        where update model message = model :> []

preMount :: forall model m message. Generic model m => EncodeRep m => String -> PreApplication model message -> Effect String
preMount selector application = do
        markup <- injectState $ application.view application.init
        rendered <- FRS.render markup
        pure rendered
        where   state = HE.createElement "template-state" [ HA.style { display: "none"}, HA.id $ "pre-mount-" <> selector, HA.createAttribute ("__pre-mount-" <> selector) selector] <<< DAC.stringify $ EGR.genericEncodeJson application.init

                headBody (Node tag nodeData children) = tag == "head" || tag == "body"
                headBody _ = false

                inject (Node tag nodeData children) = Node tag nodeData (state : children)
                inject node = node

                injectState (Text _) = EE.throw "Error pre mounting application: cannot mount on text node!"
                injectState (Node tag nodeData children)
                        | tag == "html" =
                                pure <<< Node tag nodeData $
                                        case DA.findIndex headBody children of
                                                Nothing -> state : children
                                                Just index -> unsafePartial (DM.fromJust $ DA.modifyAt index inject children)
                        | otherwise = pure <<< Node tag nodeData $ state : children

-- -- | Mount a Flame application on the given selector which was rendered server-side
-- resumeMount :: forall model message. String -> ResumedApplication model message -> Effect (Channel (Array message))
-- resumeMount selector application = do
--         maybeEl <- FAD.querySelector selector
--         case maybeEl of
--                 Just el -> run el application
--                 Nothing -> EE.throw $ "Error mounting application: no element matching selector " <> show selector <> " found!"

-- -- | Mount a Flame application on the given selector which was rendered server-side, discarding the message Channel
-- resumeMount_ :: forall model message. String -> ResumedApplication model message -> Effect Unit
-- resumeMount_ selector application = do
--         _ <- resumeMount selector application
--         pure unit

-- | Mount a Flame application on the given selector
mount :: forall model message. String -> Application model message -> Effect (Channel (Array message))
mount selector application = do
        maybeEl <- FAD.querySelector selector
        case maybeEl of
                Just el -> run el application
                Nothing -> EE.throw $ "Error mounting application: no element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. String -> Application model message -> Effect Unit
mount_ selector application = do
        _ <- mount selector application
        pure unit

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run :: forall model message. DOMElement -> Application model message -> Effect (Channel (Array message))
run el application = do
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
                        updatedVNode <- FR.render currentVNode (const <<< runUpdate) $ application.view model
                        ER.write { model, vNode: updatedVNode } state

        initialVNode <- FR.renderInitial el (const <<< runUpdate) $ application.view initialModel
        ER.write { model: initialModel, vNode: initialVNode } state

        runMessages initialAffs

        --signals are used for some dom events as well user supplied custom events
        channel <- SC.channel []
        S.runSignal <<< map (DF.traverse_ runUpdate) $ SC.subscribe channel
        pure channel