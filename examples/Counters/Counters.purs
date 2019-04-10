module Examples.Counters.Main where

import Prelude

import Data.Array ((!!))
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Effect (Effect)
import Effect.Aff (Aff)
import Examples.Counter.Main as EC
import Flame (Html, World)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Html.Event as HV

type Model = Array EC.Model

data Message = Add | Remove Int | CounterMsg Int EC.Message

init :: Model
init = []

update :: World Model Message -> Model -> Message -> Aff Model
update _ model Add = pure $ DA.snoc model EC.init
update _ model (Remove index) = pure <<< DM.fromMaybe model $ DA.deleteAt index model
update world model (CounterMsg index message) = do
        let maybeModel = model !! index
        case maybeModel of
                Nothing -> pure model
                Just model' -> do
                        updated <- EC.update world model' message
                        pure $ DM.fromMaybe model $ DA.updateAt index updated model

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HV.onClick Add] "Add",
        HE.div_ $ DA.mapWithIndex viewCounter model
]
        where   viewCounter index model' = HE.div [HA.style { display: "flex" }] [
                        CounterMsg index <$> EC.view model',
                        HE.button [HV.onClick $ Remove index] "Remove"
                ]

main :: Effect Unit
main =  F.mount "main" { init, update, view, inputs: [] }
