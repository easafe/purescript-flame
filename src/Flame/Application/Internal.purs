--actually run a flame app
module Flame.Internal(World, run) where

import Flame.Type
import Effect.Aff (Aff)
import Prelude
import Data.Maybe(Maybe)

newtype World model message = World {
        update :: model -> message -> Aff model,
        view :: model -> Aff Unit
        event :: Maybe Event,
        previousModel :: model,
        previousMessage :: model
}

run :: forall model message. DOMElement -> Application model message -> Effect Unit
run el application = do
        state <- ER.new {
                model: application.init,
                vNode: FR.emptyVNode
        }

        let     --the function which actually run events
                runUpdate model message = do
                        EA.runAff_ (case _ of
                                Left error -> EC.log $ EE.message error --shouldn't stay like this
                                Right model' -> render model') $ application.update (World world) model message

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
                world = { view: \m -> reRender m, update: \m m2 -> reUpdate m m2 }

                --wrapper to process signals
                runUpdate' message = do
                        model <- _.model <$> ER.read state
                        runUpdate model message

        initialVNode <- FR.renderInitial el (runUpdate application.init) $ application.view application.init
        ER.write { model: application.init, vNode: initialVNode } state

        DF.traverse_ (S.runSignal <<< map runUpdate') application.inputs