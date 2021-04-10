module Test.ServerSideRendering.ManagedNode (preMount, mount) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..), fromJust)
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame (QuerySelector(..), Html)
import Flame as F
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame.Html.Element (NodeRenderer)
import Flame.Html.Element as HE
import Partial.Unsafe as PU
import Web.DOM.Document as WDD
import Web.DOM.Element (Element)
import Web.DOM.Element as WDE
import Web.Event.Internal.Types (Event)
import Web.HTML as WH
import Web.HTML.HTMLDocument as WHH
import Web.HTML.Window as WHW

foreign import setInnerHTML :: EffectFn2 String String Unit
foreign import setElementInnerHTML :: EffectFn2 Element String Unit

-- | The model represents the state of the app
newtype Model = Model Int

derive instance genericModel :: Generic Model _

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement Event

-- | `update` is called to handle events
update :: AffUpdate Model Message
update { model: Model m, message } =
      pure $ const (Model $ case message of
            Increment -> m + 1
            Decrement _ -> m - 1)

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "my-id" $ children model

preView :: Model -> Html Message
preView model = HE.main "my-id" $ children model

nodeRenderer :: NodeRenderer Int
nodeRenderer = {
    createNode: \arg -> do
      window <- WH.window
      document <- WHW.document window
      element <- WDD.createElement "span" $ WHH.toDocument document
      EU.runEffectFn2 setElementInnerHTML element $ show arg
      pure $ WDE.toNode element,
    updateNode: \node _ arg -> do
      EU.runEffectFn2 setElementInnerHTML (PU.unsafePartial (fromJust $ WDE.fromNode node)) $ show arg
      pure node
}

children :: Model -> Array (Html Message)
children (Model model) = [
      HE.managed nodeRenderer [HA.id "text-output"] model,
      HE.br,
      HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

preMount :: Effect Unit
preMount = do
      contents <- F.preMount (QuerySelector "#my-id") { init: Model 2, view: preView }
      EU.runEffectFn2 setInnerHTML "#mount-point" contents

-- | Mount the application on the given selector
mount :: Effect Unit
mount = FAE.resumeMount_ (QuerySelector "#my-id") {
      init: Nothing,
      subscribe: [],
      update,
      view
}