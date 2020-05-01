module Test.Basic.ContentEditable (mount) where

import Prelude

import Effect (Effect)
import Flame (QuerySelector(..), Html)
import Flame.Application.NoEffects as FAN
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = String

data Message = SetModel String

init :: Model
init = "start"

update :: Model -> Message -> Model
update _ = case _ of
        SetModel newModel -> newModel

view :: Model -> Html Message
view model = HE.main_ [
        HE.span "text-output" model,
        HE.select [HA.id "content-select", HA.createAttribute "contentEditable" "inherit", HA.onInput SetModel] [
                HE.option [HA.value "1"] "1",
                HE.option [HA.selected true, HA.value "2"] "2"
        ],
        HE.div [HA.id "content-div", HA.contentEditable true, HA.onInput SetModel] [
                HE.text "content"
        ]
]

mount :: Effect Unit
mount = FAN.mount_ (QuerySelector "#mount-point") {
                init,
                update,
                view
        }
