module Flame (Application, mount, emptyApp, module Exported, updateWith, updateWith') where

import Flame.Type
import Prelude

import Data.Either (Either(..))
import Data.Either as DE
import Data.Foldable as DF
import Effect.Uncurried as EU
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Aff.Class as AC
import Effect.Exception as EE
import Effect.Class (liftEffect)
import Effect.Console as EC
import Effect.Uncurried (EffectFn1)
import Flame.DOM as HD
import Flame.Html.Element as HHE
import Flame.Renderer as HR
import Flame.Type (Html) as Exported
import Signal (Signal)
import Signal as S
import Signal.Channel as SC

type Application model message = {
        init :: model,
        update :: model -> message -> Aff model,
        view :: model -> Html message,
        inputs :: Array (Signal message)
}

emptyApp :: Application Unit Unit
emptyApp = {
        init: unit,
        update: flip (const pure),
        view: const (HHE.createEmptyElement "bs"),
        inputs : []
}

mount :: forall model message. String -> Application model message -> Effect Unit
mount selector application = do
        maybeEl <- HD.querySelector selector
        case maybeEl of
                Just el -> startApplication el application
                Nothing -> EC.log $ "No element matching selector " <> show selector <> " found!"

startApplication :: forall model message. DOMElement -> Application model message -> Effect Unit
startApplication el application = do
        initialVNode <- HR.renderInitial el (runUpdate application.init) $ application.view application.init
        setState {
                model: application.init,
                vNode: initialVNode,
                update: application.update,
                view: application.view
        }

        DF.traverse_ (S.runSignal <<< map runUpdate') application.inputs
        where   runUpdate' message = do
                        state <- getState
                        runUpdate state.model message

runUpdate :: forall model message. model -> message -> Effect Unit
runUpdate model message =  do
        state <- getState
        EA.runAff_ (case _ of
                Left error -> EC.log $ EE.message error --shouldnt stay like this
                Right model' -> render model') $ state.update model message

render :: forall model. model -> Effect Unit
render model = do
        state <- getState
        updatedVNode <- HR.render state.vNode (runUpdate model) $ state.view model
        setState $ state { vNode = updatedVNode, model = model }

updateWith :: forall model message. model -> message -> Aff model
updateWith model message = liftEffect $ do
        runUpdate model message
        getModel

updateWith' :: forall model. model -> Aff Unit
updateWith' = liftEffect <<< render

getModel :: forall model. Effect model
getModel = do
        state <- getState
        pure state.model

type ApplicationState model message = {
        vNode :: VNodeProxy,
        model :: model,
        view :: model -> Html message,
        update :: model -> message -> Aff model
}

foreign import getState :: forall model message. Effect (ApplicationState model message)
foreign import setState_ :: forall model message. EffectFn1 (ApplicationState model message) Unit

setState :: forall model message. ApplicationState model message -> Effect Unit
setState = EU.runEffectFn1 setState_