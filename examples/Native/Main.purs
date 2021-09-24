module Examples.Native.Main where

import Flame
import Flame.Application.EffectList (mountNative_, noMessages)
import Flame.Html.Element as HE

main = mountNative_ {
    init : "hello" :> []
    ,view : \m -> HE.text m
    , update : \m _ -> noMessages m
    , subscribe: []
    , name : "test"
}