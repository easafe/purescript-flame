module Test.ServerSideRendering.Effectful (preMount, mount) where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame (QuerySelector(..), Html)
import Flame.Application.Effectful (AffUpdate)
import Flame.Application.Effectful as FAE
import Flame.Html.Attribute as HA
import Flame as F
import Flame.Html.Element as HE
import Web.Event.Internal.Types (Event)

foreign import setInnerHTML ∷ EffectFn2 String String Unit

-- | The model represents the state of the app
newtype Model = Model Int

derive instance genericModel ∷ Generic Model _

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement Event

-- | `update` is called to handle events
update ∷ AffUpdate Model Message
update { model: Model m, message } =
      pure $ const
            ( Model $ case message of
                    Increment → m + 1
                    Decrement _ → m - 1
            )

-- | `view` is called whenever the model is updated
view ∷ Model → Html Message
view model = HE.main "my-id" $ children model <> [ HE.span_ "rendered!" ]

preView ∷ Model → Html Message
preView model = HE.main "my-id" $ children model

children ∷ Model → Array (Html Message)
children (Model model) =
      [ HE.span "text-output" $ show model
      , HE.br
      , HE.button [ HA.id "increment-button", HA.onClick Increment ] "+"
      ]

preMount ∷ Effect Unit
preMount = do
      contents ← F.preMount (QuerySelector "#my-id") { init: Model 2, view: preView }
      EU.runEffectFn2 setInnerHTML "#mount-point" contents

-- | Mount the application on the given selector
mount ∷ Effect Unit
mount = FAE.resumeMount_ (QuerySelector "#my-id")
      { init: Nothing
      , subscribe: []
      , update
      , view
      }