module Test.ServerSideRendering.Effectful (preMount, mount) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame (Html)
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Web.Event.Internal.Types (Event)

foreign import setInnerHTML :: EffectFn2 String String Unit

-- | The model represents the state of the app
newtype Model = Model Int

derive instance genericModle :: Generic Model _

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement Event

-- | `update` is called to handle events
update :: _ -> Model -> Message -> Aff Model
update _ (Model model) =
        pure <<< Model <<< (case _ of
                Increment -> model + 1
                Decrement _ -> model - 1)

-- | `view` is called whenever the model is updated
view :: Model -> Html Message
view model = HE.main "main" $ children model <> [HE.span_ "rendered!"]

preView :: Model -> Html Message
preView model = HE.main "main" $ children model

children :: Model -> Array (Html Message)
children (Model model) = [
        HE.span "text-output" $ show model,
        HE.br,
        HE.button [HA.id "increment-button", HA.onClick Increment] "+"
]

preMount :: Effect Unit
preMount = do
        contents <- F.preMount "main" { init: Model 2, view: preView }
        EU.runEffectFn2 setInnerHTML "#mount-point" contents

-- | Mount the application on the given selector
mount :: Effect Unit
mount = F.resumeMount_ "main" {
                init: Nothing,
                update,
                view
        }