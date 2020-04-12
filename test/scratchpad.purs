-- | Testing playground, do not depend on this file
module Test.ScratchPad where

import Prelude

import Data.Maybe (Maybe(..))
import Data.String as DS
import Data.String.CodeUnits as DSC
import Data.Tuple (Tuple)
import Debug.Trace (spy)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..))
import Effect.Aff as AF
import Effect.Class (liftEffect)
import Effect.Random as ER
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = Int

data Message = Overwrite Int | Overwrite0 Int | Overwrite1 Int

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
        Overwrite m -> m :> []
        Overwrite0 m -> m :> [do
                AF.delay $ Milliseconds 4000.0
                pure $ Just $ Overwrite (spy "overwrite 1" 1),
                pure $ Just $ Overwrite (spy "overwrite 2" 2),
                pure $ Just $ Overwrite1 (spy "overwrite 3" 2)
        ]
        Overwrite1 m -> m :> [     do
                AF.delay $ Milliseconds 8000.0
                pure $ Just $ Overwrite (spy "overwrite 4" 3),
                pure $ Just $ Overwrite (spy "overwrite 5" 4),
                pure $ Nothing]


view :: Model -> Html Message
view model = HE.main_ [
        HE.span [HA.id "text-output"] $ show model,
        HE.br,
        HE.input [HA.id "cut-button", HA.value "click", HA.type' "button", HA.onClick $ Overwrite0 0],
        HE.br,
        HE.input [HA.id "cubutton", HA.value "click", HA.type' "button", HA.onClick $ Overwrite1 29]
]

main :: Effect Unit
main = FAE.mount_ (QuerySelector "#mount-point") {
                init: 100 :> [],
                update,
                view
        }
