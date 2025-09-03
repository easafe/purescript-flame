module Test.Functor.Lazy where

import Data.Maybe
import Effect
import Flame
import Flame.Html.Element
import Prelude

import Data.Tuple.Nested ((/\))
import Flame.Html.Attribute as HA
import Flame.Html.Element as H
import Flame.Html.Event as E
import Web.DOM.ParentNode (QuerySelector(..))

data CounterMsg = Increment Int

type CounterModel = { count ∷ Int }

initCounter ∷ CounterModel
initCounter = { count: 1 }

updateCounter ∷ CounterModel → CounterMsg → CounterModel
updateCounter model (Increment val) = model { count = model.count + val }

counterView ∷ CounterModel → Html CounterMsg
counterView = lazy Nothing counterView_

counterView_ ∷ CounterModel → Html CounterMsg
counterView_ model = H.main "main"
      [ H.button [ HA.id "add-button", E.onClick $ Increment 1000 ] [ H.text $ "Current Value: " <> show model.count ]
      ]

data Msg = PageMsg PageMsg

data PageMsg = CounterMsg CounterMsg

type Model = { counter ∷ CounterModel }

init ∷  { counter ∷ { count :: Int } }
init = { counter: initCounter }

update :: Update Model Msg
update model (PageMsg (CounterMsg msg)) = model { counter = updateCounter model.counter msg } /\ []

view ∷ Model → Html Msg
view model = H.div_ [ PageMsg <$> CounterMsg <$> counterView model.counter ]

mount ∷ Effect Unit
mount = mount_ (QuerySelector "#mount-point")
      { subscribe: []
      , model:init
      , update
      , view
      }
