-- | The default way to run a Flame application
-- |
-- | The update function carries context information and runs on `Aff`
module Flame.Application.Effectful(
        Application,
        emptyApp,
        mount,
        mount_,
        World
)
where

import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Class (liftEffect)
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Application.EffectList ((:>))
import Flame.Application.DOM as FAD
import Flame.HTML.Element as FHE
import Flame.Renderer as FR
import Flame.Types (App, DOMElement)
import Prelude (Unit, bind, const, discard, map, pure, show, unit, ($), (<$>), (<<<), (<>))
import Signal as S
import Signal.Channel (Channel)
import Signal.Channel as SC
import Web.Event.Internal.Types (Event)

-- | `Application` contains
-- | * `init` – the initial model and an optional message to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
type Application model message = App model message (
        init :: Tuple model (Maybe message),
        update :: World model message -> model -> message -> Aff model
)

-- | `World` contains context information for `Application.update`
-- | * `update` – recurse `Application.update` with given model and message
-- | * `view` – forcefully update view with given model
-- | * `event` – the `Event` currently being handled
-- | * `previousModel` – model before last update
-- | * `previousMessage` – last message raised
type World model message = {
        update :: model -> message -> Aff model,
        view :: model -> Aff Unit,
        event :: Maybe Event,
        previousModel :: Maybe model,
        previousMessage :: Maybe message
}

-- | A bare bones application
emptyApp :: Application Unit Unit
emptyApp = {
        init: unit :> Nothing,
        update,
        view: const (FHE.createEmptyElement "bs")
}
        where update f model message = pure model

-- | Mount a Flame application on the given selector
mount :: forall model message. String -> Application model message -> Effect (Channel (Maybe message))
mount selector application = do
        maybeEl <- FAD.querySelector selector
        case maybeEl of
                Just el -> run el application
                Nothing -> EE.throw $ "No element matching selector " <> show selector <> " found!"

-- | Mount a Flame application on the given selector, discarding the message Channel
mount_ :: forall model message. String -> Application model message -> Effect Unit
mount_ selector application = do
        _ <- mount selector application
        pure unit

-- | `run` keeps the state in a `Ref` and call `Flame.Renderer.render` for every update
run :: forall model message. DOMElement -> Application model message -> Effect (Channel (Maybe message))
run el application = do
        let Tuple initialModel initialMessage = application.init
        state <- ER.new {
                previousModel: Nothing,
                previousMessage: Nothing,
                model: initialModel,
                vNode: FR.emptyVNode
        }

        let     --the function which actually run events
                runUpdate model message event = do
                        st <- ER.read state
                        let world = createWorld st.previousModel st.previousMessage event
                        EA.runAff_ (case _ of
                                Left error -> EC.log $ EE.message error --shouldn't stay like this
                                Right model' -> render (Just message) model') $ application.update world model message

                --the function which renders to the dom
                render previousMessage model = do
                        currentVNode <- _.vNode <$> ER.read state
                        updatedVNode <- FR.render currentVNode (runUpdate model) $ application.view model
                        modifyState (\st -> st {
                                previousModel = Just st.model,
                                previousMessage = previousMessage,
                                model = model,
                                vNode = updatedVNode
                        })

                --the function application.update uses instead of recursion
                reUpdate model message event = liftEffect $ do
                        runUpdate model message event
                        _.model <$> ER.read state

                --the function application.update uses to forcefully render
                reRender model = liftEffect $ render Nothing model

                --first parameter of application.update
                createWorld previousModel previousMessage event = {
                        view: \model -> reRender model,
                        update: \model message -> reUpdate model message event,
                        previousModel,
                        previousMessage,
                        event
                }

                --wrapper to process signals
                runUpdate' message = do
                        model <- _.model <$> ER.read state
                        --it might be that we can get the event from the signal?
                        runUpdate model message Nothing

                modifyState st = do
                        _ <- ER.modify st state
                        pure unit

        initialVNode <- FR.renderInitial el (runUpdate initialModel) $ application.view initialModel
        modifyState (\st -> st { vNode = initialVNode })

        case initialMessage of
                Nothing -> pure unit
                Just message -> runUpdate initialModel message Nothing

        --signals are used for some dom events as well user supplied custom events
        channel <- SC.channel Nothing
        S.runSignal <<< map (DF.traverse_ runUpdate') <<< S.filter DM.isJust Nothing $ SC.subscribe channel
        pure channel