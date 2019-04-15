module Test.EffectList where

import Prelude

import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.String as DS
import Data.String.CodeUnits as DSC
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (Html)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = String

data Message = Current String | Cut

update :: Model -> Message -> Tuple Model (Array (Aff Message))
update model = case _ of
        Cut -> model :> [
                Current <$> cut model
        ]
        Current text -> text :> []
        where   cut text = do
                        amount <- liftEffect <<< ER.randomInt 0 $ DSC.length text
                        pure $ DS.take amount text

view :: Model -> Html Message
view model = HE.main_ [
        HE.span [HA.id "text-output"] model,
        HE.input [HA.type' "text", HA.onInput Current],
        HE.input [HA.id "cut-button", HA.type' "button", HA.onClick Cut]
]

main :: Effect Unit
main = FAE.mount "main" {
        init: "" :> [],
        update: update,
        view,
        inputs:[]
}
