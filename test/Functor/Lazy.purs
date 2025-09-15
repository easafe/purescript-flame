module Test.Functor.Lazy where

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Prelude

import Data.Tuple.Nested ((/\))
import Flame (Html, Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

data CounterMsg = Increment Int

type CounterModel = { count ∷ Int }

initCounter ∷ CounterModel
initCounter = { count: 1 }

updateCounter ∷ CounterModel → CounterMsg → CounterModel
updateCounter model (Increment val) = model { count = model.count + val }

counterView ∷ CounterModel → Html CounterMsg
counterView = HE.lazy Nothing counterView_

counterView_ ∷ CounterModel → Html CounterMsg
counterView_ model = HE.main [ HA.id "main" ]
      [ HE.button [ HA.id "add-button", HA.onClick $ Increment 1000 ] [ HE.text $ "Current Value: " <> show model.count ]
      ]

data Msg = PageMsg PageMsg

data PageMsg = CounterMsg CounterMsg

type Model = { counter ∷ CounterModel }

init ∷ { counter ∷ { count ∷ Int } }
init = { counter: initCounter }

update ∷ Update Model Msg
update model (PageMsg (CounterMsg msg)) = model { counter = updateCounter model.counter msg } /\ []

view ∷ Model → Html Msg
view model = HE.div_ [ PageMsg <$> CounterMsg <$> counterView model.counter ]

mount ∷ Effect Unit
mount = F.mount_ (QuerySelector "#mount-point")
      { subscribe: []
      , model: init
      , update
      , view
      }
