module Examples.Native.Main where

import Flame
import Prelude

import Effect (Effect)
import Flame.Application.EffectList (mountNative_, noMessages)
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE

main :: Effect Unit
main = mountNative_ {
    init : "hello" :> []
    ,view : \m -> HE.fragment [
        HE.div [HA.nativeStyle {color: "red"}] m,
        HE.br,
        HE.b_ "OLA"
    ]
    , update : \m _ -> noMessages m
    , subscribe: []
    , name : "test"
}