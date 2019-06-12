-- | The Elm like way to run a Flame application
-- |
-- | The update function returns an array of side effects
module Flame.Application.EffectList(
        Application,
        emptyApp,
        mount,
        mount_,
        (:>)
)
where

import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.DOM as FD
import Flame.HTML.Element as FHE
import Flame.Renderer as FR
import Flame.Types (App, DOMElement)
import Prelude (Unit, bind, const, discard, map, pure, show, unit, ($), (<$>), (<<<), (<>))
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

-- | Infix tuple constructor
infixr 6 Tuple as :>

-- | A bare bones application
emptyApp :: Application Unit Unit
emptyApp = {
        init: unit :> [],
        update,
        view: const (FHE.createEmptyElement "bs")
}
        where update model message = model :> []

-- | Mount a Flame application in the given selector
mount :: forall model message. String -> Application model message -> Effect (Channel (Array message))
mount selector application = do
        maybeEl <- FD.querySelector selector
        case maybeEl of
                Just el -> run el application
                Nothing -> EE.throw $ "No element matching selector " <> show selector <> " found!"

-- | Mount a Flame application in the given selector, discarding the message Channel
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