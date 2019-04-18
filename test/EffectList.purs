module Test.EffectList (mount) where

import Prelude

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
                        amount <- liftEffect <<< ER.randomInt 1 $ DSC.length text
                        pure $ DS.take amount text

view :: Model -> Html Message
view model = HE.main_ [
        HE.span [HA.id "text-output"] model,
        HE.input [HA.id "text-input", HA.type' "text", HA.onInput Current],
        HE.input [HA.id "cut-button", HA.type' "button", HA.onClick Cut]
]

mount :: Effect Unit
mount = FAE.mount "#mount-point" {
        init: "" :> [],
        update: update,
        view,
        inputs:[]
}
