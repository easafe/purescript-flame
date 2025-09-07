module Examples.NoEffects.Counters.Main where

import Prelude

import Data.Array ((!!))
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Tuple as DT
import Effect (Effect)
import Examples.NoEffects.Counter.Main as ECM
import Flame (Html, Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Web.DOM.ParentNode (QuerySelector(..))

type Model = Array ECM.Model

data Message = Add | Remove Int | CounterMessage Int ECM.Message

init ∷ Model
init = []

update ∷ Update Model Message
update model = F.noMessages <<< case _ of
      Add → DA.snoc model ECM.init
      Remove index → DM.fromMaybe model $ DA.deleteAt index model
      CounterMessage index message →
            case model !! index of
                  Nothing → model
                  Just model' → DM.fromMaybe model $ DA.updateAt index (DT.fst $ ECM.update model' message) model

view ∷ Model → Html Message
view model = HE.main [ HA.id "main" ]
      [ HE.button [ HA.onClick Add ] [ HE.text "Add" ]
      , HE.div_ $ DA.mapWithIndex viewCounter model
      ]
      where
      viewCounter index model' = HE.div [ HA.style { display: "flex" } ]
            [ CounterMessage index <$> ECM.view model'
            , HE.button [ HA.onClick $ Remove index ] [ HE.text "Remove" ]
            ]

main ∷ Effect Unit
main = F.mount_ (QuerySelector "body")
      { model: init
      , subscribe: []
      , update
      , view
      }
