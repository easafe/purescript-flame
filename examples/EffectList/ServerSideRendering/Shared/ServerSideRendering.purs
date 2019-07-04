-- | Definitions commom to server and client
-- |
-- | The same view, and model type are reused; the generic instance is necessary to serialize the inital state
module Examples.EffectList.ServerSideRendering.Shared where

import Prelude

import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe)
import Flame (QuerySelector(..), Html)
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

newtype Model = Model (Maybe Int)

derive instance modelGeneric :: Generic Model _

data Message = Roll | Update Int

view :: Model -> Html Message
view (Model model) = HE.main "main" [
                HE.text (show model),
                HE.button [HA.onClick Roll] "Roll"
        ]