module Flame (Application, mount, emptyApp, module Exported, Update) where

import Flame.Type
import Prelude

import Control.Monad.Trans.Class (class MonadTrans)
import Data.Either (Either(..))
import Data.Either as DE
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Aff.Class as AC
import Effect.Class (liftEffect)
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Effect.Uncurried (EffectFn1)
import Effect.Uncurried as EU
import Flame.DOM as HD
import Flame.Html.Element as FHE
import Flame.Renderer as FR
import Flame.Type (Html) as Exported
import Signal (Signal)
import Signal as S
import Signal.Channel as SC

type Update model message = {
        with :: model -> message -> Aff model,
        model :: model -> Aff Unit
}

type Application model message = {
        --init needs to be the same type as update
        init :: model,
        update :: Update model message -> model -> message -> Aff model,
        view :: model -> Html message,
        inputs :: Array (Signal message)
}

emptyApp :: Application Unit Unit
emptyApp = {
        init: unit,
        update,
        view: const (FHE.createEmptyElement "bs"),
        inputs : []
}
        where update f model message = pure model

mount :: forall model message. String -> Application model message -> Effect Unit
mount selector application = do
        maybeEl <- HD.querySelector selector
        case maybeEl of
                Just el -> startApplication el application
                Nothing -> EC.log $ "No element matching selector " <> show selector <> " found!"

startApplication :: forall model message. DOMElement -> Application model message -> Effect Unit
startApplication el application = do
        state <- ER.new {
                model: application.init,
                vNode: FR.emptyVNode
        }

        let     --the function which actually run events
                runUpdate model message = do
                        EA.runAff_ (case _ of
                                Left error -> EC.log $ EE.message error --shouldn't stay like this
                                Right model' -> render model') $ application.update update model message

                --the function which renders to the dom
                render model = do
                        currentVNode <- _.vNode <$> ER.read state
                        updatedVNode <- FR.render currentVNode (runUpdate model) $ application.view model
                        ER.write { vNode: updatedVNode, model } state

                --the function application.update uses instead of recursion
                reUpdate model message = liftEffect $ do
                        runUpdate model message
                        _.model <$> ER.read state

                --the function application.update uses to forcefully render
                reRender model = liftEffect $ render model

                --first parameter of application.update
                update = { model: \m -> reRender m, with: \m m2 -> reUpdate m m2}

                --wrapper to process signals
                runUpdate' message = do
                        model <- _.model <$> ER.read state
                        runUpdate model message

        initialVNode <- FR.renderInitial el (runUpdate application.init) $ application.view application.init
        ER.write { model: application.init, vNode: initialVNode } state

        DF.traverse_ (S.runSignal <<< map runUpdate') application.inputs