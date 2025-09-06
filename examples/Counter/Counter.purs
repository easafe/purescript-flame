-- | Counter example using side effects free updating
module Examples.NoEffects.Counter.Main where

import Prelude

import Effect (Effect)
import Flame (Html, Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

-- | The model represents the state of the app
type Model = Int

-- | This datatype is used to signal events to `update`
data Message = Increment | Decrement

-- | Initial state of the app
init ∷ Model
init = 0

-- | `update` is called to handle events
update ∷ Update Model  Message
update model = F.noMessages <<< case _ of
      Increment → model + 1
      Decrement → model - 1

-- | `view` updates the app markup whenever the model is updated
view ∷ Model → Html Message
view model = HE.main [HA.id "main"]
      [ HE.button [ HA.onClick Decrement ] [HE.text "-"]
      , HE.text $ show model
      , HE.button [ HA.onClick Increment ] [HE.text "+"]
      ]

-- | Mount the application on the given selector
main ∷ Effect Unit
main = F.mount_ (QuerySelector "body")
      { model: init
      , subscribe: []
      , update
      , view
      }